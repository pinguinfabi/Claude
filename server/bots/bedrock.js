'use strict'
const bedrock = require('bedrock-protocol')
const { preset } = require('./authopts')

// Bedrock-Adapter (bedrock-protocol)
exports.connect = function connect (ctx) {
  const opts = {
    host: ctx.host,
    port: ctx.port,
    username: ctx.id,
    offline: ctx.offline,
    profilesFolder: ctx.profiles,
    raknetBackend: process.env.BOT_RAKNET || 'raknet-native',
    connectTimeout: 20000,
    onMsaCode: ctx.onMsaCode,
    ...preset()
  }
  if (ctx.version) opts.version = ctx.version
  const c = bedrock.createClient(opts)

  c.on('packet', () => ctx.packet())
  c.on('session', () => ctx.authenticated && ctx.authenticated())
  c.on('join', () => ctx.join())
  c.on('spawn', () => ctx.spawn())
  c.on('kick', p => ctx.kick(p && (p.message || p.reason)))
  // Ein einzelnes unlesbares Paket (z. B. "Read error ... Invalid tag") beendet die Verbindung NICHT:
  // die Bibliothek liest das naechste Paket normal weiter. Nur echte Verbindungsfehler fuehren zum Relog.
  const PARSE_RE = /Read error|Parse error|PartialReadError|Invalid tag|Unexpected buffer end|Chunk size is/i
  let parseErrors = 0
  let lastParseNote = 0
  c.on('error', e => {
    const msg = e && e.message ? e.message : String(e)
    if (PARSE_RE.test(msg)) {
      parseErrors++
      if (Date.now() - lastParseNote > 60000) {
        lastParseNote = Date.now()
        ctx.diag && ctx.diag(`Unlesbares Paket ignoriert (${parseErrors}x): ${msg.slice(0, 120)}`)
      }
      return
    }
    ctx.closed('Fehler: ' + msg)
  })
  c.on('close', () => ctx.closed('Verbindung geschlossen'))
  c.on('text', p => {
    try {
      let msg = String(p.message || '')
      if (Array.isArray(p.parameters) && p.parameters.length) msg = `${msg} ${p.parameters.join(' ')}`.trim()
      if (!msg) return
      ctx.chat({ kind: p.type === 'chat' ? 'chat' : 'system', from: p.type === 'chat' ? p.source_name : '', msg })
    } catch (e) { /* unbekanntes Textpaket */ }
  })

  return {
    raw: c, // nur fuer Tests
    setSneak: on => {
      c.queue('player_action', {
        runtime_entity_id: BigInt(c.entityId || 0),
        action: on ? 'start_sneak' : 'stop_sneak',
        position: { x: 0, y: 0, z: 0 },
        result_position: { x: 0, y: 0, z: 0 },
        face: 0
      })
    },
    close: () => { try { c.disconnect('Bot beendet') } catch (e) { c.close() } },
    say: text => {
      if (text.startsWith('/')) {
        c.queue('command_request', {
          command: text,
          origin: { type: 'player', uuid: '', request_id: '', player_entity_id: '' },
          internal: false,
          version: '1'
        })
      } else {
        c.queue('text', {
          type: 'chat',
          needs_translation: false,
          source_name: c.username || ctx.id,
          xuid: '',
          platform_chat_id: '',
          filtered_message: '',
          message: text
        })
      }
    },
    keepalive: () => c.queue('animate', { action_id: 'swing_arm', runtime_entity_id: c.entityId })
  }
}
