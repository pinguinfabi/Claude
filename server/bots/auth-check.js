'use strict'
// Diagnose: findet heraus, bei welchem Schritt die Microsoft-/Xbox-Anmeldung eines Kontos scheitert.
//   node auth-check.js <j1..j5|b1..b5>
const fs = require('fs')
const path = require('path')
const { Authflow } = require('prismarine-auth')
const { hint, watchAuthErrors } = require('./authhint')
const { preset } = require('./authopts')

const id = process.argv[2]
if (!/^[jb][1-9]\d*$/.test(id || '')) {
  console.error('Aufruf: node auth-check.js <j1..j5 | b1..b5>')
  process.exit(2)
}
const isJava = id[0] === 'j'
const dir = path.join(process.env.BOT_DIR || __dirname, 'profiles', id)
fs.mkdirSync(dir, { recursive: true })

const errors = []
const authName = process.env.BOT_AUTH || 'switch'
const flow = new Authflow(id, dir, preset(authName), data => {
  console.log('\n==================== MICROSOFT-LOGIN ====================')
  console.log(` 1. Im Browser oeffnen: ${data.verification_uri}`)
  console.log(` 2. Code eingeben:      ${data.user_code}`)
  console.log(' 3. Mit dem Konto anmelden, das zu diesem Bot gehoert.')
  console.log('==========================================================\n')
})

function spy (obj, name, label) {
  const orig = obj[name].bind(obj)
  obj[name] = async (...a) => {
    try {
      const r = await orig(...a)
      console.log(`  ok      ${label}`)
      return r
    } catch (e) {
      const msg = String(e && e.message || e).split('\n')[0]
      if (!errors.length) console.log(`  FEHLER  ${label}: ${msg}`)
      errors.push({ label, msg, full: String(e && e.message || e) })
      throw e
    }
  }
}
spy(flow.msa, 'authDeviceCode', 'Microsoft-Anmeldung')
spy(flow.xbl, 'getUserToken', 'Xbox-Benutzer-Token')
spy(flow.xbl, 'getDeviceToken', 'Xbox-Geraete-Token')
spy(flow.xbl, 'getXSTSToken', 'Xbox-Sicherheitstoken (XSTS)')
if (isJava) {
  spy(flow.mca, 'getAccessToken', 'Minecraft-Java-Token')
  spy(flow.mca, 'fetchProfile', 'Minecraft-Java-Profil')
}

watchAuthErrors(text => {
  console.log(`\nURSACHE (erster Fehler, Schritt "Microsoft-Anmeldung"):\n  ${text.split('\n').join('\n  ')}`)
  console.log(`\nHINWEIS: ${hint(text)}`)
  process.exit(1)
})

console.log(`Pruefe Konto fuer Bot ${id} (${isJava ? 'Java' : 'Bedrock'}), Anmeldeweg: ${authName} ...`)
;(async () => {
  try {
    if (isJava) {
      const r = await flow.getMinecraftJavaToken({ fetchProfile: true })
      if (!r.profile || r.profile.error) throw new Error('Kein Minecraft-Java-Profil – besitzt das Konto Minecraft Java? ' + JSON.stringify(r.profile || {}))
      console.log(`\nERFOLG: Anmeldung ok, Spielername: ${r.profile.name}`)
      if (authName !== 'switch') console.log(`Diesen Weg dauerhaft nutzen:  bot-login ${id} ${authName}`)
    } else {
      await flow.getXboxToken('https://multiplayer.minecraft.net/')
      console.log('\nERFOLG: Xbox-Anmeldung fuer Bedrock ist ok.')
    }
    process.exit(0)
  } catch (e) {
    const first = errors[0] || { label: 'unbekannt', full: String(e && e.message || e) }
    console.log(`\nURSACHE (erster Fehler, Schritt "${first.label}"):\n  ${first.full.split('\n').join('\n  ')}`)
    console.log(`\nHINWEIS: ${hint(first.full)}`)
    process.exit(1)
  }
})()
