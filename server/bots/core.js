'use strict'
// Gemeinsamer Kern fuer alle Chat-Bots (Java "j*" und Bedrock "b*"):
//   * Status-Datei (fuer die VNC-Steuerung), Relog bei Kick/Abbruch/Funkstille, geplanter Relog
//   * Chat-Schnittstelle fuer den Windows-Controller (lokaler TCP-Port, JSON pro Zeile)
const fs = require('fs')
const path = require('path')
const net = require('net')

const env = (k, d) => (process.env[k] !== undefined && process.env[k] !== '' ? process.env[k] : d)

function run ({ id, type, adapter }) {
  const loginMode = process.argv.includes('--login')
  const HOST = env('BOT_HOST', 'hugosmp.net')
  const PORT = parseInt(env('BOT_PORT', env(type === 'java' ? 'BOT_JAVA_PORT' : 'BOT_BEDROCK_PORT', type === 'java' ? '25565' : '19132')), 10)
  const VERSION = env('BOT_VERSION', env(type === 'java' ? 'BOT_JAVA_VERSION' : 'BOT_BEDROCK_VERSION', ''))
  const RELOG_MINUTES = parseFloat(env('RELOG_MINUTES', '0'))
  const ANTI_AFK = env('ANTI_AFK', 'none') // none | swing
  const OFFLINE = env('BOT_OFFLINE', '0') === '1' // nur fuer Tests
  const BASE_DIR = env('BOT_DIR', __dirname)
  const PROFILES = path.join(BASE_DIR, 'profiles', id)
  const STATE_DIR = env('BOT_STATE_DIR', path.join(BASE_DIR, 'state'))
  const defaultControl = (type === 'java' ? 6100 : 6200) + parseInt(id.slice(1), 10)
  const CONTROL_PORT = parseInt(env('BOT_CONTROL_PORT', String(defaultControl)), 10)
  const BACKOFF_BASE_MS = parseInt(env('BOT_BACKOFF_BASE_MS', '15000'), 10)
  const BACKOFF_MAX_MS = parseInt(env('BOT_BACKOFF_MAX_MS', '300000'), 10)
  const SILENCE_MS = parseInt(env('BOT_SILENCE_MS', '90000'), 10)
  const STABLE_MS = parseInt(env('BOT_STABLE_MS', '60000'), 10)
  const CONNECT_MS = parseInt(env('BOT_CONNECT_MS', '75000'), 10)

  fs.mkdirSync(PROFILES, { recursive: true })
  fs.mkdirSync(STATE_DIR, { recursive: true })
  const log = (...a) => console.log(new Date().toISOString(), `[${id}]`, ...a)

  // Sperre: pro Bot darf nur EIN Prozess laufen (sonst zerstoeren sich zwei Anmeldungen gegenseitig)
  const lockFile = path.join(STATE_DIR, id + '.lock')
  try {
    const other = parseInt(fs.readFileSync(lockFile, 'utf8'), 10)
    if (other && other !== process.pid) {
      let alive = false
      try { process.kill(other, 0); alive = true } catch (e) { /* tot */ }
      if (alive) {
        console.error(`Bot ${id} laeuft schon (PID ${other}). Zuerst beenden:  kill ${other}`)
        process.exit(3)
      }
    }
  } catch (e) { /* keine Sperre vorhanden */ }
  fs.writeFileSync(lockFile, String(process.pid))
  const removeLock = () => { try { if (fs.readFileSync(lockFile, 'utf8') === String(process.pid)) fs.unlinkSync(lockFile) } catch (e) { /* egal */ } }
  process.on('exit', removeLock)

  // ---------- Statusdatei ----------
  let state = 'connecting'
  function writeState () {
    try {
      const f = path.join(STATE_DIR, id)
      fs.writeFileSync(f + '.tmp', state + '\n')
      fs.renameSync(f + '.tmp', f)
    } catch (e) { log('Statusdatei nicht schreibbar:', e.message) }
  }
  function setState (s) {
    state = s
    writeState()
    broadcast({ t: 'state', state })
  }
  const heartbeat = setInterval(writeState, 15000)

  // ---------- Chat-Schnittstelle ----------
  const history = []
  const clients = new Set()
  function send (sock, obj) { try { sock.write(JSON.stringify(obj) + '\n') } catch (e) { /* Verbindung weg */ } }
  function broadcast (obj) { for (const s of clients) send(s, obj) }
  function pushChat (entry) {
    entry.ts = Date.now()
    history.push(entry)
    if (history.length > 300) history.shift()
    broadcast({ t: 'chat', ...entry })
    log(entry.kind === 'self' ? '>>' : '<<', entry.from ? `${entry.from}: ${entry.msg}` : entry.msg)
  }
  let lastSay = 0
  function handleLine (sock, line) {
    let m
    try { m = JSON.parse(line) } catch (e) { return }
    if (m.t !== 'say') return
    const text = typeof m.msg === 'string' ? m.msg.replace(/[\r\n]+/g, ' ').trim() : ''
    if (!text || text.length > 256) return send(sock, { t: 'error', msg: 'Nachricht leer oder laenger als 256 Zeichen.' })
    if (!client || dead || state !== 'online') return send(sock, { t: 'error', msg: 'Bot ist nicht im Spiel.' })
    if (Date.now() - lastSay < 800) return send(sock, { t: 'error', msg: 'Bitte kurz warten (Spam-Schutz).' })
    lastSay = Date.now()
    try {
      client.say(text)
      pushChat({ kind: 'self', from: 'Du', msg: text })
    } catch (e) {
      send(sock, { t: 'error', msg: 'Senden fehlgeschlagen: ' + e.message })
    }
  }
  if (!loginMode) {
    const srv = net.createServer(sock => {
      sock.setEncoding('utf8')
      clients.add(sock)
      send(sock, { t: 'hello', id, type, state })
      for (const h of history) send(sock, { t: 'chat', ...h, old: true })
      let buf = ''
      sock.on('data', d => {
        buf += d
        if (buf.length > 4096) buf = ''
        let i
        while ((i = buf.indexOf('\n')) >= 0) { handleLine(sock, buf.slice(0, i)); buf = buf.slice(i + 1) }
      })
      sock.on('close', () => clients.delete(sock))
      sock.on('error', () => clients.delete(sock))
    })
    srv.on('error', e => log('Chat-Port', CONTROL_PORT, 'nicht nutzbar:', e.message))
    srv.listen(CONTROL_PORT, '127.0.0.1')
  }

  // ---------- Verbindungsschleife ----------
  let client = null // { close(), say(text), keepalive?() }
  let dead = true
  let attempt = 0
  let onlineSince = 0
  let lastPacket = 0
  let connectStart = 0
  let reconnectTimer = null
  let relogTimer = null
  let afkTimer = null
  let stopping = false
  let loginDone = false

  function connect () {
    clearTimeout(reconnectTimer)
    setState('connecting')
    dead = false
    lastPacket = connectStart = Date.now()
    log(`Verbinde mit ${HOST}:${PORT} (${type}) ...`)

    const mine = { conn: null }
    const guard = fn => (...a) => { if (mine.conn === client || mine.conn === null) fn(...a) }
    const ctx = {
      id, host: HOST, port: PORT, version: VERSION, offline: OFFLINE, profiles: PROFILES, log,
      onMsaCode,
      authenticated: () => {
        if (!loginMode || loginDone) return
        loginDone = true
        log('Microsoft-Login erfolgreich und gespeichert. Beende in 3 s ...')
        setTimeout(() => shutdown(0), 3000)
      },
      packet: () => { lastPacket = Date.now() },
      join: () => log('Login ok, Welt wird geladen ...'),
      spawn: guard(() => {
        if (state === 'online') return
        onlineSince = Date.now()
        setState('online')
        log('ONLINE – im Spiel gespawnt.')
        startKeepalive()
        if (loginMode) {
          log('Login erfolgreich gespeichert. Beende in 5 s ...')
          setTimeout(() => shutdown(0), 5000)
        } else if (RELOG_MINUTES > 0) {
          const ms = RELOG_MINUTES * 60000 * (0.9 + Math.random() * 0.2)
          relogTimer = setTimeout(() => drop(mine.conn, `geplanter Relog nach ${Math.round(ms / 60000)} min`, true), ms)
        }
      }),
      chat: e => { if (!loginMode) pushChat(e) },
      kick: text => log('Vom Server getrennt:', String(text || '').replace(/\n/g, ' ')),
      closed: reason => drop(mine.conn, reason || 'Verbindung geschlossen')
    }
    try {
      mine.conn = adapter.connect(ctx)
    } catch (e) {
      log('Fehler beim Erstellen des Clients:', e.message)
      dead = true
      return scheduleReconnect('createClient')
    }
    client = mine.conn
  }

  function onMsaCode (data) {
    const url = data.verification_uri || 'https://www.microsoft.com/link'
    if (loginMode) {
      console.log('\n==================== MICROSOFT-LOGIN ====================')
      console.log(` 1. Auf deinem PC im Browser oeffnen: ${url}`)
      console.log(` 2. Diesen Code eingeben:  ${data.user_code}`)
      console.log(' 3. Mit dem Minecraft-Konto fuer diesen Bot anmelden.')
      console.log('==========================================================\n')
    } else {
      setState('login')
      log(`LOGIN NOETIG – bitte auf dem Server ausfuehren: bot-login ${id}`)
      shutdown(78) // 78 = kein Neustart durch systemd
    }
  }

  function startKeepalive () {
    clearInterval(afkTimer)
    if (ANTI_AFK !== 'swing' || !client || !client.keepalive) return
    const c = client
    afkTimer = setInterval(() => {
      try { if (client === c && state === 'online') c.keepalive() } catch (e) { log('Anti-AFK fehlgeschlagen:', e.message) }
    }, 25000 + Math.floor(Math.random() * 15000))
  }

  const isAuthError = r => /invalid_grant|device_code|authorization code|XSTS|xbl|authenticat/i.test(String(r))
  let authWipes = 0

  function drop (c, reason, immediate = false) {
    if (!c || client !== c || dead) return
    dead = true
    log('Getrennt:', reason)
    clearTimeout(relogTimer)
    clearInterval(afkTimer)
    try { c.close() } catch (e) { /* schon zu */ }
    client = null
    if (stopping) return
    if (isAuthError(reason) && !loginDone) {
      if (loginMode && authWipes < 2) {
        authWipes++
        log('Gespeicherte Anmeldedaten sind defekt – loesche sie und frage einen neuen Code an ...')
        try { fs.rmSync(PROFILES, { recursive: true, force: true }); fs.mkdirSync(PROFILES, { recursive: true }) } catch (e) { /* egal */ }
        return scheduleReconnect(reason, true)
      }
      if (!loginMode) {
        setState('login')
        log(`Anmeldung ungueltig/abgelaufen – bitte auf dem Server ausfuehren: bot-login ${id}`)
        return shutdown(78)
      }
    }
    if (onlineSince && Date.now() - onlineSince >= STABLE_MS) attempt = 0
    onlineSince = 0
    scheduleReconnect(reason, immediate)
  }

  function scheduleReconnect (reason, immediate = false) {
    setState('connecting')
    if (loginMode && !loginDone && attempt >= 3) { log('Login nicht moeglich (Server nicht erreichbar?).'); return shutdown(1) }
    const base = Math.min(BACKOFF_BASE_MS * 2 ** attempt, BACKOFF_MAX_MS)
    const delay = immediate ? 3000 : Math.round(base * (0.8 + Math.random() * 0.4))
    attempt++
    log(`Neuer Versuch in ${Math.round(delay / 1000)} s (Versuch ${attempt}).`)
    reconnectTimer = setTimeout(connect, delay)
  }

  setInterval(() => {
    if (!client || dead) return
    if (state === 'connecting' && !loginMode && Date.now() - connectStart > CONNECT_MS) {
      drop(client, `Verbindungsaufbau dauert laenger als ${Math.round(CONNECT_MS / 1000)} s`)
    } else if (state === 'online' && Date.now() - lastPacket > SILENCE_MS) {
      drop(client, `keine Daten seit ${Math.round(SILENCE_MS / 1000)} s`)
    }
  }, 10000)

  function shutdown (code) {
    if (stopping) return
    stopping = true
    clearInterval(heartbeat)
    clearTimeout(reconnectTimer)
    clearTimeout(relogTimer)
    clearInterval(afkTimer)
    try { if (client) client.close('Bot beendet') } catch (e) { /* egal */ }
    setTimeout(() => process.exit(code), 500)
  }
  process.on('SIGTERM', () => shutdown(0))
  process.on('SIGINT', () => shutdown(0))
  process.on('SIGHUP', () => shutdown(0))
  process.on('uncaughtException', e => { log('Unerwarteter Fehler:', (e && e.stack) || e); if (client) drop(client, 'Ausnahme') })
  process.on('unhandledRejection', e => { log('Unbehandelte Ablehnung:', (e && e.message) || e); if (client) drop(client, 'Ablehnung') })

  connect()
}

module.exports = { run }
