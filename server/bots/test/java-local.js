// Lokaler Test des Java-Chat-Bots: Testserver (1.12.2) + Chat-Port-Client + Kick/Relog.
const mc = require('minecraft-protocol')
const net = require('net')
const { spawn } = require('child_process')
const path = require('path')
const os = require('os')
const fs = require('fs')

const VERSION = '1.12.2'
const PORT = 25599
const CONTROL = 6190
const results = {}
let joins = 0
let serverGot = null

const server = mc.createServer({ 'online-mode': false, host: '127.0.0.1', port: PORT, version: VERSION, maxPlayers: 5 })
server.on('login', client => {
  joins++
  client.write('login', { entityId: client.id, levelType: 'default', gameMode: 0, dimension: 0, difficulty: 2, maxPlayers: 20, reducedDebugInfo: false })
  client.write('position', { x: 0, y: 64, z: 0, yaw: 0, pitch: 0, flags: 0, teleportId: 0 })
  if (joins > 1) client.write('update_health', { health: 20, food: 20, foodSaturation: 5 }) // 1. Join: kein Spawn-Signal -> Fallback
  setTimeout(() => client.write('chat', { message: JSON.stringify({ text: '<Steve> hallo bot' }), position: 0 }), 2500)
  client.on('chat', p => { serverGot = p.message; console.log('[test] Server erhielt Chat:', p.message) })
  if (joins === 1) setTimeout(() => client.end('Test-Kick (AFK)'), 9000)
})

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'jbot-'))
const bot = spawn('node', [path.join(__dirname, '..', 'bot.js'), 'j9'], {
  env: { ...process.env, BOT_HOST: '127.0.0.1', BOT_PORT: String(PORT), BOT_OFFLINE: '1', BOT_DIR: dir, BOT_VERSION: VERSION,
    BOT_CONTROL_PORT: String(CONTROL), BOT_FALLBACK_MS: '2000', BOT_BACKOFF_BASE_MS: '1000', BOT_BACKOFF_MAX_MS: '3000' },
  stdio: ['ignore', 'pipe', 'pipe']
})
bot.stdout.on('data', d => process.stdout.write('[bot] ' + d))
bot.stderr.on('data', d => process.stdout.write('[bot-err] ' + d))

const lines = []
setTimeout(() => {
  const sock = net.connect(CONTROL, '127.0.0.1')
  let buf = ''
  sock.on('data', d => {
    buf += d
    let i
    while ((i = buf.indexOf('\n')) >= 0) {
      const o = JSON.parse(buf.slice(0, i)); buf = buf.slice(i + 1)
      lines.push(o); console.log('[test] Controller sieht:', JSON.stringify(o))
    }
  })
  setTimeout(() => sock.write(JSON.stringify({ t: 'say', msg: 'Hallo aus dem Controller' }) + '\n'), 4000)
  setTimeout(() => sock.write(JSON.stringify({ t: 'say', msg: '/home base' }) + '\n'), 5500)
}, 2000)

setTimeout(() => {
  bot.kill('SIGTERM')
  setTimeout(() => {
    const chatIn = lines.some(l => l.t === 'chat' && /hallo bot/.test(l.msg))
    const sentOk = lines.some(l => l.t === 'chat' && l.kind === 'self' && l.msg === 'Hallo aus dem Controller')
    const cmdOk = lines.some(l => l.t === 'chat' && l.kind === 'self' && l.msg === '/home base')
    const relog = joins >= 2
    const notes = lines.some(l => l.t === 'chat' && l.kind === 'system' && /Getrennt|Neuer Versuch/.test(l.msg))
    const fallback = lines.some(l => l.t === 'chat' && l.kind === 'system' && /kein Spawn-Signal/.test(l.msg))
    console.log(`\n[test] Chat empfangen: ${chatIn}\n[test] Nachricht gesendet+bestaetigt: ${sentOk} (Server: ${serverGot})\n[test] Befehl gesendet: ${cmdOk}\n[test] Relog nach Kick: ${relog} (Joins ${joins})\n[test] Grund im Chat sichtbar: ${notes}\n[test] Online per Fallback: ${fallback}`)
    process.exit(chatIn && sentOk && cmdOk && relog && notes && fallback ? 0 : 1)
  }, 1500)
}, 20000)
