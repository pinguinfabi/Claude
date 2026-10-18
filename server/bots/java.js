'use strict'
const mineflayer = require('mineflayer')
const { preset } = require('./authopts')

// Java-Adapter (mineflayer): stehen bleiben, Chat lesen und schreiben
exports.connect = function connect (ctx) {
  const opts = {
    host: ctx.host,
    port: ctx.port,
    username: ctx.id,
    auth: ctx.offline ? 'offline' : 'microsoft',
    profilesFolder: ctx.profiles,
    onMsaCode: ctx.onMsaCode,
    ...preset(),
    checkTimeoutInterval: 60000,
    hideErrors: true
  }
  if (ctx.version) opts.version = ctx.version
  const bot = mineflayer.createBot(opts)
  let ended = false

  // Diagnose: Zustandswechsel und erste Pakete jeder Art melden, damit man sieht, wo ein Aufbau haengt
  const seen = new Set()
  bot._client.on('connect', () => ctx.diag && ctx.diag('TCP-Verbindung steht'))
  bot._client.on('state', (n, o) => ctx.diag && ctx.diag(`Zustand ${o} -> ${n}`))
  bot._client.on('packet', (data, meta) => {
    const k = `${meta.state}:${meta.name}`
    if (!seen.has(k) && seen.size < 40 && ctx.diag) { seen.add(k); ctx.diag('Paket ' + k) }
  })
  bot.once('inject_allowed', () => ctx.diag && ctx.diag('Erkannte Version: ' + bot.version))

  // Fehler in mineflayer: Die Antwort auf ein Server-Resource-Pack traegt die UUID 000...0 statt der des Packs.
  // Server mit Pflicht-Pack (z. B. hugosmp.net) warten dann ewig in der Konfigurationsphase.
  // -> selbst mit der richtigen UUID antworten und die fehlerhafte Standardantwort unterdruecken.
  const rawWrite = bot._client.write.bind(bot._client)
  bot._client.write = (name, params, ...rest) => {
    if (name === 'resource_pack_receive' && params && params.uuid !== undefined && typeof params.uuid !== 'string') return undefined
    return rawWrite(name, params, ...rest)
  }
  bot._client.on('add_resource_pack', data => {
    try {
      ctx.diag && ctx.diag(`Resource-Pack angefordert (${data.uuid}) – antworte mit passender UUID`)
      rawWrite('resource_pack_receive', { uuid: data.uuid, result: 3 }) // angenommen
      rawWrite('resource_pack_receive', { uuid: data.uuid, result: 0 }) // geladen
    } catch (e) { ctx.diag && ctx.diag('Resource-Pack-Antwort fehlgeschlagen: ' + e.message) }
  })

  bot._client.on('packet', () => ctx.packet())
  bot._client.on('session', () => ctx.authenticated && ctx.authenticated())
  bot._client.on('login', () => ctx.join())
  bot.once('spawn', () => ctx.spawn())
  bot.on('messagestr', (msg, position, json) => {
    if (!msg || !msg.trim()) return
    const m = /^<([^>]{1,32})> (.*)$/s.exec(msg)
    ctx.chat(m ? { kind: 'chat', from: m[1], msg: m[2] } : { kind: position === 'game_info' ? 'system' : 'chat', from: '', msg })
  })
  bot.on('kicked', reason => {
    let text = reason
    try { text = typeof reason === 'string' ? reason : JSON.stringify(reason) } catch (e) { /* roh lassen */ }
    ctx.kick(text)
  })
  // Einzelne unlesbare Pakete beenden die Verbindung nicht (Relog nur bei echten Verbindungsfehlern)
  const PARSE_RE = /Read error|Parse error|PartialReadError|Invalid tag|Unexpected buffer end|Chunk size is/i
  let parseErrors = 0
  let lastParseNote = 0
  bot.on('error', e => {
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
  bot.on('end', reason => { ended = true; ctx.closed('Verbindung beendet' + (reason ? `: ${reason}` : '')) })

  return {
    raw: bot, // nur fuer Tests
    close: () => { if (!ended) { try { bot.end('Bot beendet') } catch (e) { /* schon zu */ } } },
    say: text => bot.chat(text),
    keepalive: () => bot.swingArm('right')
  }
}
