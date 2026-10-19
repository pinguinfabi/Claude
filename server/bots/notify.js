'use strict'
// Discord-Benachrichtigungen (Webhook) fuer die Chat-Bots.
// Konfiguration ueber Umgebungsvariablen (common.env):
//   BOT_DISCORD_WEBHOOK  Webhook-URL (GEHEIM, nie ins Repo!)    BOT_DISCORD_ROLE  Rollen-ID, die gepingt wird
//   BOT_LABEL            optionaler Anzeigename des Bots (env/<id>.env)
const env = (k, d) => (process.env[k] !== undefined && process.env[k] !== '' ? process.env[k] : d)

function create ({ id, type, log }) {
  const url = env('BOT_DISCORD_WEBHOOK', '')
  const roleRaw = env('BOT_DISCORD_ROLE', '')
  const role = /^\d{5,25}$/.test(roleRaw) ? roleRaw : ''
  const label = env('BOT_LABEL', '')
  const name = `${type === 'java' ? 'Java' : 'Bedrock'}-Bot ${id}${label ? ` (${label})` : ''}`
  const enabled = /^https?:\/\//.test(url)
  const pending = new Set()
  const lastSent = {}

  async function post (text, ping) {
    const mention = ping && role ? `<@&${role}> ` : ''
    const body = {
      username: 'Bot-Wächter',
      content: (mention + text).slice(0, 1900),
      // nur die eigene Rolle darf gepingt werden (nie @everyone aus Kick-Texten)
      allowed_mentions: { parse: [], roles: ping && role ? [role] : [] }
    }
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(8000)
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
  }

  // kind: Art der Nachricht (je Art hoechstens eine pro Minute), ping: Rolle erwaehnen
  function send (kind, text, { ping = true, minGapMs = 60000 } = {}) {
    if (!enabled) return
    const now = Date.now()
    if (lastSent[kind] && now - lastSent[kind] < minGapMs) return
    lastSent[kind] = now
    const p = post(text, ping)
      .catch(e => log('Discord-Nachricht fehlgeschlagen:', e.message))
      .finally(() => pending.delete(p))
    pending.add(p)
  }

  return { enabled, name, send, post, flush: () => Promise.allSettled([...pending]) }
}

module.exports = { create }
