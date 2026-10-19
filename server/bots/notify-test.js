'use strict'
// Sendet eine Testnachricht an den konfigurierten Discord-Webhook (Aufruf ueber:  bot-webhook test)
const { create } = require('./notify')
const n = create({ id: 'test', type: 'java', log: console.log })
if (!n.enabled) {
  console.log('Discord-Webhook ist NICHT eingerichtet (bot-webhook set <URL>).')
  process.exit(1)
}
n.post('🧪 Testnachricht von **bot-webhook**: Der Alarm bei Bot-Trennungen funktioniert.', true)
  .then(() => { console.log('Testnachricht gesendet (mit Rollen-Ping, falls BOT_DISCORD_ROLE gesetzt ist).'); process.exit(0) })
  .catch(e => { console.log('FEHLER beim Senden: ' + e.message + ' (URL pruefen / Webhook in Discord noch vorhanden?)'); process.exit(1) })
