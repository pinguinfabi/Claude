'use strict'
// Gemeinsamer Kern fuer alle Chat-Bots (Java "j*" und Bedrock "b*"):
//   * Status-Datei (fuer die VNC-Steuerung), Relog bei Kick/Abbruch/Funkstille, geplanter Relog
//   * Chat-Schnittstelle fuer den Windows-Controller (lokaler TCP-Port, JSON pro Zeile)
const fs = require('fs')
const path = require('path')
const net = require('net')
const { hint, watchAuthErrors } = require('./authhint')
const { create: createNotifier } = require('./notify')

const env = (k, d) => (process.env[k] !== undefined && process.env[k] !== '' ? process.env[k] : d)

function run ({ id, type, adapter }) {
  const loginMode = process.argv.includes('--login')
  const HOST = env('BOT_HOST', 'hugosmp.net')
  const PORT = parseInt(env('BOT_PORT', env(type === 'java' ? 'BOT_JAVA_PORT' : 'BOT_BEDROCK_PORT', type === 'java' ? '25565' : '19132')), 10)
  // Java: feste, bewaehrte Version (wie die funktionierenden Prism-Clients); die automatisch erkannte "26.1" bleibt in der Konfigurationsphase haengen
  const VERSION = env('BOT_VERSION', env(type === 'java' ? 'BOT_JAVA_VERSION' : 'BOT_BEDROCK_VERSION', type === 'java' ? '1.21.8' : ''))
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
  const FALLBACK_MS = parseInt(env('BOT_FALLBACK_MS', '12000'), 10) // Verbindung steht, aber kein Spawn-Signal

  fs.mkdirSync(PROFILES, { recursive: true })
  fs.mkdirSync(STATE_DIR, { recursive: true })
  const log = (...a) => console.log(new Date().toISOString(), `[${id}]`, ...a)

  // Discord-Benachrichtigung (nur im Dienstbetrieb, nicht beim Login)
  const notify = loginMode ? { enabled: false, name: id, send () {}, flush: () => Promise.resolve() } : createNotifier({ id, type, log })
  const ALERT_AFTER_MS = parseInt(env('BOT_ALERT_AFTER_MIN', '10'), 10) * 60000
  let offlineSince = Date.now() // seit wann der Bot nicht im Spiel ist
  let alertedDown = false // fuer diesen Ausfall wurde schon gemeldet
  let lastKick = ''
  let lastDelaySec = 0

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
  function pushChat (entry, quiet = false) {
    entry.ts = Date.now()
    history.push(entry)
    if (history.length > 300) history.shift()
    broadcast({ t: 'chat', ...entry })
    if (!quiet) log(entry.kind === 'self' ? '>>' : '<<', entry.from ? `${entry.from}: ${entry.msg}` : entry.msg)
  }
  // Wichtige Ereignisse (Kick, Relog, Online ...) erscheinen auch im Chat-Fenster der App
  const note = m => { if (!loginMode) pushChat({ kind: 'system', from: '', msg: '⚙ ' + m }, true) }
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
  let joinTimer = null
  let lastDiag = ''

  function connect () {
    clearTimeout(reconnectTimer)
    setState('connecting')
    dead = false
    lastPacket = connectStart = Date.now()
    lastDiag = ''
    lastKick = ''
    log(`Verbinde mit ${HOST}:${PORT} (${type}) ...`)

    const mine = { conn: null }
    const guard = fn => (...a) => { if (mine.conn === client || mine.conn === null) fn(...a) }
    const ctx = {
      id, host: HOST, port: PORT, version: VERSION, offline: OFFLINE, profiles: PROFILES, log,
      onMsaCode,
      // Verbindungsdiagnose: wo haengt der Aufbau? (Journal immer, Chat nur in den ersten Versuchen)
      diag: m => { lastDiag = m; log('  .', m); if (attempt < 3) note(m) },
      authenticated: () => {
        if (!loginMode || loginDone) return
        loginDone = true
        log('Microsoft-Login erfolgreich und gespeichert. Beende in 3 s ...')
        setTimeout(() => shutdown(0), 3000)
      },
      packet: () => { lastPacket = Date.now() },
      join: () => {
        log('Login ok, Welt wird geladen ...')
        note('Login ok, Welt wird geladen ...')
        clearTimeout(joinTimer)
        joinTimer = setTimeout(() => {
          if (state !== 'online' && mine.conn && mine.conn === client && !dead) goOnline(mine, 'Verbindung steht (kein Spawn-Signal vom Server)')
        }, FALLBACK_MS)
      },
      spawn: guard(() => goOnline(mine, 'im Spiel gespawnt')),
      chat: e => { if (!loginMode) pushChat(e) },
      kick: text => {
        const t = String(text || '').replace(/\n/g, ' ')
        lastKick = t
        log('Vom Server getrennt:', t)
        note('Vom Server getrennt: ' + t)
      },
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

  function goOnline (mine, why) {
    if (state === 'online' || !mine.conn) return
    clearTimeout(joinTimer)
    onlineSince = Date.now()
    setState('online')
    log(`ONLINE – ${why}.`)
    note(`ONLINE – ${why}`)
    if (alertedDown) {
      const mins = Math.max(1, Math.round((Date.now() - offlineSince) / 60000))
      notify.send('up', `✅ **${notify.name}** ist wieder online (Ausfall: ca. ${mins} min).`, { ping: false, minGapMs: 0 })
    }
    alertedDown = false
    offlineSince = 0
    startKeepalive()
    if (loginMode) {
      log('Login erfolgreich gespeichert. Beende in 5 s ...')
      setTimeout(() => shutdown(0), 5000)
    } else if (RELOG_MINUTES > 0) {
      const ms = RELOG_MINUTES * 60000 * (0.9 + Math.random() * 0.2)
      relogTimer = setTimeout(() => drop(mine.conn, `geplanter Relog nach ${Math.round(ms / 60000)} min`, true), ms)
    }
  }

  function onMsaCode (data) {
    const url = data.verification_uri || data.verificationUri || 'https://www.microsoft.com/link'
    const userCode = data.user_code || data.userCode
    if (!userCode) return // Microsoft hat keinen Code geliefert -> der folgende Anmeldefehler wird erklaert
    if (loginMode) {
      console.log('\n==================== MICROSOFT-LOGIN ====================')
      console.log(` 1. Auf deinem PC im Browser oeffnen: ${url}`)
      console.log(` 2. Diesen Code eingeben:  ${userCode}`)
      console.log(' 3. Mit dem Minecraft-Konto fuer diesen Bot anmelden.')
      console.log('==========================================================\n')
    } else {
      setState('login')
      log(`LOGIN NOETIG – bitte auf dem Server ausfuehren: bot-login ${id}`)
      alertLogin()
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

  watchAuthErrors(text => {
    if (loginDone) return
    log('Microsoft/Xbox hat die Anmeldung abgelehnt:', text.split('\n')[0])
    log('HINWEIS:', hint(text))
    if (loginMode) return shutdown(1)
    setState('login')
    log(`Anmeldung ungueltig/abgelehnt – bitte auf dem Server ausfuehren: bot-login ${id}  (Diagnose: bot-auth-check ${id} --neu)`)
    alertLogin()
    shutdown(78)
  })

  function alertLogin () {
    notify.send('login', `🔐 **${notify.name}**: Die Microsoft-Anmeldung ist abgelaufen oder wurde abgelehnt. Bitte auf dem Server \`bot-login ${id}\` ausführen.`, { minGapMs: 0 })
  }

  const isAuthError = r => /invalid_grant|device_code|authorization code|XSTS|xbl|authenticat/i.test(String(r))
  let authWipes = 0

  function drop (c, reason, immediate = false) {
    if (!c || client !== c || dead) return
    dead = true
    log('Getrennt:', reason)
    note('Getrennt: ' + reason)
    clearTimeout(joinTimer)
    clearTimeout(relogTimer)
    clearInterval(afkTimer)
    try { c.close() } catch (e) { /* schon zu */ }
    client = null
    if (stopping) return
    const wasOnline = onlineSince > 0
    const upMin = wasOnline ? Math.max(1, Math.round((Date.now() - onlineSince) / 60000)) : 0
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
        alertLogin()
        return shutdown(78)
      }
    }
    if (onlineSince && Date.now() - onlineSince >= STABLE_MS) attempt = 0
    onlineSince = 0
    if (wasOnline) offlineSince = Date.now()
    scheduleReconnect(reason, immediate)
    if (wasOnline && !immediate && !loginMode) {
      alertedDown = true
      notify.send('down', `⚠️ **${notify.name}** wurde getrennt.\nGrund: ${lastKick || reason}\nWar ${upMin} min online. Neuer Versuch in ca. ${lastDelaySec} s.`)
    }
  }

  function scheduleReconnect (reason, immediate = false) {
    setState('connecting')
    if (loginMode && !loginDone && attempt >= 3) { log('Login nicht moeglich (Server nicht erreichbar?).'); return shutdown(1) }
    const base = Math.min(BACKOFF_BASE_MS * 2 ** attempt, BACKOFF_MAX_MS)
    const delay = immediate ? 3000 : Math.round(base * (0.8 + Math.random() * 0.4))
    attempt++
    lastDelaySec = Math.round(delay / 1000)
    log(`Neuer Versuch in ${Math.round(delay / 1000)} s (Versuch ${attempt}).`)
    note(`Neuer Versuch in ${Math.round(delay / 1000)} s (Versuch ${attempt})`)
    reconnectTimer = setTimeout(connect, delay)
  }

  setInterval(() => {
    if (!client || dead) return
    if (state === 'connecting' && !loginMode && Date.now() - connectStart > CONNECT_MS) {
      drop(client, `Verbindungsaufbau dauert laenger als ${Math.round(CONNECT_MS / 1000)} s${lastDiag ? ` (zuletzt: ${lastDiag})` : ''}`)
    } else if (state === 'online' && Date.now() - lastPacket > SILENCE_MS) {
      drop(client, `keine Daten seit ${Math.round(SILENCE_MS / 1000)} s`)
    }
  }, 10000)

  // Bot kommt dauerhaft nicht ins Spiel (z. B. Konto belegt, Server gesperrt): einmal melden
  setInterval(() => {
    if (loginMode || state === 'online' || alertedDown || !offlineSince) return
    if (Date.now() - offlineSince >= ALERT_AFTER_MS) {
      alertedDown = true
      const mins = Math.round((Date.now() - offlineSince) / 60000)
      notify.send('offline', `⚠️ **${notify.name}** ist seit ${mins} min nicht im Spiel.\nLetzter Grund: ${lastKick || lastDiag || 'unbekannt'}\nDer Bot versucht es weiter.`, { minGapMs: 0 })
    }
  }, 30000)

  function shutdown (code) {
    if (stopping) return
    stopping = true
    clearInterval(heartbeat)
    clearTimeout(reconnectTimer)
    clearTimeout(relogTimer)
    clearInterval(afkTimer)
    try { if (client) client.close('Bot beendet') } catch (e) { /* egal */ }
    const wait = Promise.race([notify.flush(), new Promise(resolve => setTimeout(resolve, 4000))])
    setTimeout(() => wait.then(() => process.exit(code)), 500)
  }
  process.on('SIGTERM', () => shutdown(0))
  process.on('SIGINT', () => shutdown(0))
  process.on('SIGHUP', () => shutdown(0))
  process.on('uncaughtException', e => { log('Unerwarteter Fehler:', (e && e.stack) || e); if (client) drop(client, 'Ausnahme') })
  process.on('unhandledRejection', e => { log('Unbehandelte Ablehnung:', (e && e.message) || e); if (client) drop(client, 'Ablehnung') })

  connect()
}

module.exports = { run }
