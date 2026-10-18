// Testet, dass der Java-Bot ein Pflicht-Resource-Pack in der Konfigurationsphase mit der RICHTIGEN UUID beantwortet.
const mc = require('minecraft-protocol')
const { spawn } = require('child_process')
const fs = require('fs'), os = require('os'), path = require('path')
const server = mc.createServer({ 'online-mode': false, host: '127.0.0.1', port: 25588, version: '1.21.8', hideErrors: false })
let recv = []
server.on('login', client => {
  const orig = client.write.bind(client)
  let held = null
  client.write = (name, params) => {
    if (name === 'finish_configuration') {
      held = [name, params]
      console.log('[srv] Konfig fertig, aber erst Resource-Pack schicken und auf Antwort warten')
      orig('add_resource_pack', { uuid: '11111111-2222-3333-4444-555555555555', url: 'https://example.invalid/p.zip', hash: '', forced: true })
      return
    }
    return orig(name, params)
  }
  client.on('resource_pack_receive', p => {
    recv.push(p.result); console.log('[srv] Antwort auf Pack: result=' + p.result + ' uuid=' + p.uuid)
    if (p.result === 0 && held) { const h = held; held = null; orig(...h) }
  })
  client.on('error', e => console.log('[srv] client error', e.message))
})
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'pk-'))
const bot = spawn('node', [require('path').join(__dirname, '..', 'bot.js'), 'j8'], { env: { ...process.env, BOT_HOST: '127.0.0.1', BOT_PORT: '25588', BOT_OFFLINE: '1', BOT_DIR: dir, BOT_VERSION: '1.21.8', BOT_CONNECT_MS: '15000', BOT_CONTROL_PORT: '6188' }, stdio: ['ignore', 'pipe', 'pipe'] })
bot.stdout.on('data', d => process.stdout.write('[bot] ' + d)); bot.stderr.on('data', d => process.stdout.write('[bot-err] ' + d))
setTimeout(() => { bot.kill('SIGTERM'); setTimeout(() => { console.log('\nAntworten des Bots auf das Pack:', JSON.stringify(recv)); process.exit(0) }, 800) }, 14000)
