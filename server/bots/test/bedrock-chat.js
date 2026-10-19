// Testet den Bedrock-Adapter direkt: Chat/Befehl senden und Text empfangen (Testserver ohne Spielwelt).
const bedrock = require('bedrock-protocol')
const adapter = require('../bedrock')
const os = require('os')
const fs = require('fs')
const path = require('path')

const got = {}
const actions = []
const inputs = []
const server = bedrock.createServer({ host: '127.0.0.1', port: 19198, offline: true, maxPlayers: 5 })
server.on('connect', client => {
  client.on('text', p => { got.text = p; console.log('[test] Server erhielt text:', JSON.stringify({ type: p.type, source_name: p.source_name, message: p.message })) })
  client.on('player_auth_input', p => { inputs.push(p.input_data) })
  client.on('player_action', p => { actions.push(p.action); console.log('[test] Server erhielt player_action:', p.action) })
  client.on('command_request', p => { got.cmd = p; console.log('[test] Server erhielt command_request:', p.command) })
  client.on('join', () => {
    setTimeout(() => client.queue('text', { type: 'chat', needs_translation: false, source_name: 'Steve', xuid: '', platform_chat_id: '', filtered_message: '', message: 'hallo bot' }), 1500)
  })
})

const events = []
const conn = adapter.connect({
  id: 'b9', host: '127.0.0.1', port: 19198, version: '', offline: true,
  profiles: fs.mkdtempSync(path.join(os.tmpdir(), 'bprof-')), onMsaCode () {},
  packet () {}, join: () => { events.push('join'); console.log('[test] join') }, spawn () {},
  chat: e => { events.push(e); console.log('[test] Bot sieht Chat:', JSON.stringify(e)) },
  kick () {}, closed (r) { console.log('[test] closed:', r) }
})
setTimeout(() => { conn.say('Hallo vom Controller'); conn.say('/home base'); conn.setSneak(true); setTimeout(() => conn.setSneak(false), 400) }, 3000)
setTimeout(() => {
  const ok1 = got.text && got.text.message === 'Hallo vom Controller'
  const ok2 = got.cmd && got.cmd.command === '/home base'
  const ok3 = events.some(e => e.msg === 'hallo bot' && e.from === 'Steve')
  const has = (f, n) => Array.isArray(f) ? f.includes(n) : !!(f && f[n])
  const ok4 = actions.includes('start_sneak') && actions.includes('stop_sneak') &&
    inputs.some(f => has(f, 'start_sneaking')) && inputs.filter(f => has(f, 'sneaking')).length >= 4 && inputs.some(f => has(f, 'stop_sneaking'))
  console.log(`[test] Eingabepakete (player_auth_input): ${inputs.length}, davon schleichend: ${inputs.filter(f => has(f, 'sneaking')).length}`)
  console.log(`\n[test] Sneaken an/aus: ${ok4}\n[test] Chat gesendet: ${!!ok1}\n[test] Befehl gesendet: ${!!ok2}\n[test] Chat empfangen: ${!!ok3}`)
  process.exit(ok1 && ok2 && ok3 && ok4 ? 0 : 1)
}, 8000)
