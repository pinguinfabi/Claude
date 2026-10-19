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
  c.on('close', () => { clearInterval(sneakTimer); ctx.closed('Verbindung geschlossen') })
  c.on('text', p => {
    try {
      let msg = String(p.message || '')
      if (Array.isArray(p.parameters) && p.parameters.length) msg = `${msg} ${p.parameters.join(' ')}`.trim()
      if (!msg) return
      ctx.chat({ kind: p.type === 'chat' ? 'chat' : 'system', from: p.type === 'chat' ? p.source_name : '', msg })
    } catch (e) { /* unbekanntes Textpaket */ }
  })

  // --- Sneaken: Eigene Position/Blickrichtung mitfuehren, damit die Eingabedaten zur Serversicht passen ---
  const SNEAK_MODE = process.env.BOT_BEDROCK_SNEAK || 'both' // action | input | both
  let pos = { x: 0, y: 0, z: 0 }
  let pitch = 0
  let yaw = 0
  let headYaw = 0
  let tick = 0n
  let sneakTimer = null
  c.on('start_game', p => {
    try {
      if (p.player_position) pos = { x: p.player_position.x, y: p.player_position.y, z: p.player_position.z }
      if (p.rotation) { pitch = p.rotation.x; yaw = p.rotation.z; headYaw = yaw }
      if (p.current_tick !== undefined) tick = BigInt(p.current_tick)
    } catch (e) { /* unbekanntes Format */ }
  })
  c.on('move_player', p => {
    try {
      if (c.entityId !== undefined && String(p.runtime_id) === String(c.entityId)) {
        pos = { x: p.position.x, y: p.position.y, z: p.position.z }
        pitch = p.pitch; yaw = p.yaw; headYaw = p.head_yaw
      }
    } catch (e) { /* egal */ }
  })
  c.on('correct_player_move_prediction', p => {
    try { if (p.position) pos = { x: p.position.x, y: p.position.y, z: p.position.z } } catch (e) { /* egal */ }
  })
  // Ab Bedrock 1.26.40 sind die Eingabedaten eine Liste von Namen, davor eine Flaggen-Sammlung
  const verAtLeast = (v, w) => {
    const a = String(v).split('.').map(Number)
    const b = w.split('.').map(Number)
    for (let i = 0; i < 3; i++) if ((a[i] || 0) !== (b[i] || 0)) return (a[i] || 0) > (b[i] || 0)
    return true
  }
  function authInput (flags) {
    const rad = Math.PI / 180
    tick += 1n
    const inputData = verAtLeast(c.options.version, '1.26.40') ? Object.keys(flags).filter(k => flags[k]) : flags
    c.queue('player_auth_input', {
      pitch,
      yaw,
      position: pos,
      move_vector: { x: 0, z: 0 },
      head_yaw: headYaw,
      input_data: inputData,
      input_mode: 'mouse',
      play_mode: 'normal',
      interaction_model: 'classic',
      interact_rotation: { x: pitch, z: yaw },
      tick,
      delta: { x: 0, y: 0, z: 0 },
      analogue_move_vector: { x: 0, z: 0 },
      camera_orientation: {
        x: -Math.sin(yaw * rad) * Math.cos(pitch * rad),
        y: -Math.sin(pitch * rad),
        z: Math.cos(yaw * rad) * Math.cos(pitch * rad)
      },
      raw_move_vector: { x: 0, z: 0 }
    })
  }

  return {
    raw: c, // nur fuer Tests
    setSneak: on => {
      if (SNEAK_MODE !== 'input') {
        // alter Weg (Server ohne eigene Bewegungspruefung): einzelner Aktionsbefehl
        c.queue('player_action', {
          runtime_entity_id: BigInt(c.entityId || 0),
          action: on ? 'start_sneak' : 'stop_sneak',
          position: { x: 0, y: 0, z: 0 },
          result_position: { x: 0, y: 0, z: 0 },
          face: 0
        })
      }
      if (SNEAK_MODE === 'action') return
      // Server mit eigener Bewegungspruefung (z. B. Geyser) liest das Schleichen aus den Eingabedaten,
      // die ein echter Client 20x pro Sekunde schickt -> waehrend des Schleichens genauso senden.
      clearInterval(sneakTimer)
      sneakTimer = null
      if (on) {
        authInput({ start_sneaking: true, sneak_pressed_raw: true, sneaking: true, sneak_down: true, sneak_current_raw: true })
        sneakTimer = setInterval(() => {
          try { authInput({ sneaking: true, sneak_down: true, sneak_current_raw: true }) } catch (e) { /* Verbindung weg */ }
        }, 50)
      } else {
        authInput({ stop_sneaking: true, sneak_released_raw: true })
      }
    },
    close: () => { clearInterval(sneakTimer); try { c.disconnect('Bot beendet') } catch (e) { c.close() } },
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
