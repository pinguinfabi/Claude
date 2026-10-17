// Lokaler Test: Testserver kickt jeden Client kurz nach dem Join -> der Bot muss sich selbst neu einloggen.
const bedrock = require('bedrock-protocol')
const { spawn } = require('child_process')
const path = require('path')
const os = require('os')
const fs = require('fs')

const server = bedrock.createServer({ host: '127.0.0.1', port: 19199, offline: true, maxPlayers: 5 })
let joins = 0
server.on('connect', client => {
  client.on('join', () => {
    joins++
    console.log(`[test] Server: Join #${joins} von ${client.getUserData().displayName}`)
    setTimeout(() => client.disconnect('Test-Kick (AFK)'), 1500)
  })
})

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'botdir-'))
const bot = spawn('node', [path.join(__dirname, '..', 'bot.js'), 'btest'], {
  env: { ...process.env, BOT_HOST: '127.0.0.1', BOT_PORT: '19199', BOT_OFFLINE: '1', BOT_DIR: dir,
    BOT_BACKOFF_BASE_MS: '1000', BOT_BACKOFF_MAX_MS: '4000' },
  stdio: ['ignore', 'pipe', 'pipe']
})
let out = ''
bot.stdout.on('data', d => { out += d; process.stdout.write('[bot] ' + d) })
bot.stderr.on('data', d => { out += d; process.stdout.write('[bot-err] ' + d) })
setTimeout(() => {
  bot.kill('SIGTERM')
  setTimeout(() => {
    const ok = joins >= 3
    console.log(`\n[test] Joins am Server: ${joins} -> ${ok ? 'BESTANDEN (Relog funktioniert)' : 'FEHLGESCHLAGEN'}`)
    console.log('[test] Statusdatei:', fs.readFileSync(path.join(dir, 'state', 'btest'), 'utf8').trim())
    process.exit(ok ? 0 : 1)
  }, 1500)
}, 25000)
