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
  bot.on('error', e => ctx.closed('Fehler: ' + (e && e.message ? e.message : e)))
  bot.on('end', reason => { ended = true; ctx.closed('Verbindung beendet' + (reason ? `: ${reason}` : '')) })

  return {
    close: () => { if (!ended) { try { bot.end('Bot beendet') } catch (e) { /* schon zu */ } } },
    say: text => bot.chat(text),
    keepalive: () => bot.swingArm('right')
  }
}
