// Testet: ein unlesbares Paket beendet die Verbindung NICHT, ein echter Verbindungsfehler schon.
const bedrock = require('bedrock-protocol')
const adapter = require('../bedrock')
const os = require('os'), fs = require('fs'), path = require('path')

const server = bedrock.createServer({ host: '127.0.0.1', port: 19197, offline: true, maxPlayers: 5 })
server.on('connect', client => client.on('join', () => setTimeout(() => client.disconnect('Test-Ende'), 9000)))
const log = []
const conn = adapter.connect({
  id: 'b7', host: '127.0.0.1', port: 19197, version: '', offline: true,
  profiles: fs.mkdtempSync(path.join(os.tmpdir(), 'pe-')), onMsaCode () {},
  packet () {}, join: () => log.push('join'), spawn () {}, chat () {}, kick () {},
  diag: m => { log.push('diag:' + m); console.log('[test] diag:', m) },
  closed: r => { log.push('closed:' + r); console.log('[test] closed:', r) }
})
setTimeout(() => conn.raw.emit('error', new Error('Read error for undefined : Invalid tag: 115 > 20')), 3000)
setTimeout(() => conn.raw.emit('error', new Error('Connect timed out')), 5000)
setTimeout(() => {
  const closedEarly = log.findIndex(l => l.startsWith('closed:')) 
  const diagIdx = log.findIndex(l => l.startsWith('diag:Unlesbares'))
  const ok = diagIdx >= 0 && closedEarly > diagIdx && log[closedEarly].includes('Connect timed out')
  console.log(`\n[test] Paketfehler ignoriert (kein Abbruch): ${diagIdx >= 0}\n[test] Echter Fehler fuehrt zum Abbruch: ${closedEarly > diagIdx}`)
  process.exit(ok ? 0 : 1)
}, 7000)
