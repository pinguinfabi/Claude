'use strict'
// Bedrock-AFK-Bot: loggt sich mit einem Xbox-Konto ein, joint den Server und bleibt stehen.
// Bei Kick, Verbindungsabbruch oder Funkstille wird automatisch neu eingeloggt (Relog).
//
//   node bot.js b1            Dienstmodus (immer wieder verbinden)
//   node bot.js b1 --login    Einmaliger Microsoft-Login: Code anzeigen, joinen, beenden
const fs = require('fs')
const path = require('path')
const bedrock = require('bedrock-protocol')

const id = process.argv[2] || process.env.BOT_ID
if (!id || !/^[a-z0-9_-]+$/i.test(id)) {
  console.error('Aufruf: node bot.js <id> [--login]')
  process.exit(2)
}
const loginMode = process.argv.includes('--login')

const env = (k, d) => (process.env[k] !== undefined && process.env[k] !== '' ? process.env[k] : d)
const HOST = env('BOT_HOST', 'hugosmp.net')
const PORT = parseInt(env('BOT_PORT', '19132'), 10)
const VERSION = env('BOT_VERSION', '') // leer = vom Server erkennen
const RELOG_MINUTES = parseFloat(env('RELOG_MINUTES', '0')) // 0 = nur bei Abbruch neu einloggen
const ANTI_AFK = env('ANTI_AFK', 'none') // none | swing
const OFFLINE = env('BOT_OFFLINE', '0') === '1' // nur fuer Tests
const BASE_DIR = env('BOT_DIR', __dirname)
const PROFILES = path.join(BASE_DIR, 'profiles', id)
const STATE_DIR = env('BOT_STATE_DIR', path.join(BASE_DIR, 'state'))
const BACKOFF_BASE_MS = parseInt(env('BOT_BACKOFF_BASE_MS', '15000'), 10)
const BACKOFF_MAX_MS = parseInt(env('BOT_BACKOFF_MAX_MS', '300000'), 10)
const SILENCE_MS = parseInt(env('BOT_SILENCE_MS', '90000'), 10)
const STABLE_MS = parseInt(env('BOT_STABLE_MS', '60000'), 10)
const CONNECT_MS = parseInt(env('BOT_CONNECT_MS', '75000'), 10) // so lange darf Login + Join dauern

fs.mkdirSync(PROFILES, { recursive: true })
fs.mkdirSync(STATE_DIR, { recursive: true })

const log = (...a) => console.log(new Date().toISOString(), `[${id}]`, ...a)

// --- Statusdatei: wird alle 15 s erneuert, die VNC-Steuerung liest sie ---
let state = 'connecting'
function setState (s) {
  state = s
  writeState()
}
function writeState () {
  try {
    const f = path.join(STATE_DIR, id)
    fs.writeFileSync(f + '.tmp', state + '\n')
    fs.renameSync(f + '.tmp', f)
  } catch (e) { log('Statusdatei nicht schreibbar:', e.message) }
}
const heartbeat = setInterval(writeState, 15000)

// --- Verbindungsschleife ---
let client = null
let dead = true
let attempt = 0
let onlineSince = 0
let lastPacket = 0
let connectStart = 0
let reconnectTimer = null
let relogTimer = null
let afkTimer = null
let stopping = false

function connect () {
  clearTimeout(reconnectTimer)
  setState('connecting')
  dead = false
  lastPacket = Date.now()
  connectStart = Date.now()
  log(`Verbinde mit ${HOST}:${PORT} ...`)

  const opts = {
    host: HOST,
    port: PORT,
    username: OFFLINE ? id : id,
    offline: OFFLINE,
    profilesFolder: PROFILES,
    raknetBackend: env('BOT_RAKNET', 'raknet-native'),
    connectTimeout: 20000,
    onMsaCode: onMsaCode
  }
  if (VERSION) opts.version = VERSION

  let c
  try {
    c = bedrock.createClient(opts)
  } catch (e) {
    log('Fehler beim Erstellen des Clients:', e.message)
    return scheduleReconnect('createClient')
  }
  client = c

  c.on('packet', () => { lastPacket = Date.now() })
  c.on('join', () => log('Login ok, Welt wird geladen ...'))
  c.on('spawn', () => {
    if (client !== c) return
    onlineSince = Date.now()
    setState('online')
    log('ONLINE – im Spiel gespawnt.')
    startKeepalive(c)
    if (loginMode) {
      log('Login erfolgreich gespeichert. Beende in 5 s ...')
      setTimeout(() => shutdown(0), 5000)
    } else if (RELOG_MINUTES > 0) {
      const ms = RELOG_MINUTES * 60000 * (0.9 + Math.random() * 0.2)
      relogTimer = setTimeout(() => drop(c, `geplanter Relog nach ${Math.round(ms / 60000)} min`, true), ms)
    }
  })
  c.on('kick', p => log('Vom Server getrennt:', String(p && (p.message || p.reason) || '').replace(/\n/g, ' ')))
  c.on('error', e => drop(c, 'Fehler: ' + (e && e.message ? e.message : e)))
  c.on('close', () => drop(c, 'Verbindung geschlossen'))
}

function onMsaCode (data) {
  const url = data.verification_uri || 'https://www.microsoft.com/link'
  if (loginMode) {
    console.log('\n==================== MICROSOFT-LOGIN ====================')
    console.log(` 1. Auf deinem PC im Browser oeffnen: ${url}`)
    console.log(` 2. Diesen Code eingeben:  ${data.user_code}`)
    console.log(' 3. Mit dem Xbox-/Minecraft-Konto fuer diesen Bot anmelden.')
    console.log('==========================================================\n')
  } else {
    setState('login')
    log(`LOGIN NOETIG – bitte auf dem Server ausfuehren: bedrock-login ${id}`)
    shutdown(78) // 78 = kein Neustart durch systemd
  }
}

function startKeepalive (c) {
  clearInterval(afkTimer)
  if (ANTI_AFK !== 'swing') return
  afkTimer = setInterval(() => {
    try {
      if (client === c && state === 'online') c.write('animate', { action_id: 'swing_arm', runtime_entity_id: c.entityId })
    } catch (e) { log('Anti-AFK fehlgeschlagen:', e.message) }
  }, 25000 + Math.floor(Math.random() * 15000))
}

function drop (c, reason, immediate = false) {
  if (client !== c || dead) return
  dead = true
  log('Getrennt:', reason)
  clearTimeout(relogTimer)
  clearInterval(afkTimer)
  try { c.close() } catch (e) { /* schon zu */ }
  client = null
  if (stopping) return
  if (onlineSince && Date.now() - onlineSince >= STABLE_MS) attempt = 0
  onlineSince = 0
  scheduleReconnect(reason, immediate)
}

function scheduleReconnect (reason, immediate = false) {
  setState('connecting')
  if (loginMode && attempt >= 3) { log('Login nicht moeglich (Server nicht erreichbar?).'); return shutdown(1) }
  const base = Math.min(BACKOFF_BASE_MS * 2 ** attempt, BACKOFF_MAX_MS)
  const delay = immediate ? 3000 : Math.round(base * (0.8 + Math.random() * 0.4))
  attempt++
  log(`Neuer Versuch in ${Math.round(delay / 1000)} s (Versuch ${attempt}).`)
  reconnectTimer = setTimeout(connect, delay)
}

// Funkstille bzw. haengender Verbindungsaufbau -> neu einloggen
setInterval(() => {
  if (client && !dead && state === 'connecting' && !loginMode && Date.now() - connectStart > CONNECT_MS) {
    drop(client, `Verbindungsaufbau dauert laenger als ${Math.round(CONNECT_MS / 1000)} s`)
  }
  if (client && !dead && state === 'online' && Date.now() - lastPacket > SILENCE_MS) {
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
  try { if (client) client.disconnect('Bot beendet') } catch (e) { /* egal */ }
  setTimeout(() => process.exit(code), 500)
}
process.on('SIGTERM', () => shutdown(0))
process.on('SIGINT', () => shutdown(0))
process.on('uncaughtException', e => { log('Unerwarteter Fehler:', e && e.stack || e); if (client) drop(client, 'Ausnahme') })
process.on('unhandledRejection', e => { log('Unbehandelte Ablehnung:', e && e.message || e); if (client) drop(client, 'Ablehnung') })

connect()
