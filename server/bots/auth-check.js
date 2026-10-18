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
let authOptions
try {
  authOptions = preset(authName)
} catch (e) {
  console.error('FEHLER: ' + e.message)
  process.exit(1)
}
const flow = new Authflow(id, dir, authOptions, data => {
  if (!(data.user_code || data.userCode)) return // kein Code geliefert -> der folgende Fehler wird erklaert
  console.log('\n==================== MICROSOFT-LOGIN ====================')
  console.log(` 1. Im Browser oeffnen: ${data.verification_uri || data.verificationUri || 'https://www.microsoft.com/link'}`)
  console.log(` 2. Code eingeben:      ${data.user_code || data.userCode}`)
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
      // wie bedrock-protocol: Chain + Multiplayer-Token mit einem frischen Schluessel holen
      const crypto = require('crypto')
      const key = crypto.generateKeyPairSync('ec', { namedCurve: 'secp384r1' })
      const x509 = key.publicKey.export({ type: 'spki', format: 'der' }).toString('base64')
      const login = await flow.getMinecraftBedrockToken(x509)
      const payload = JSON.parse(Buffer.from(login.chain[1].split('.')[1], 'base64').toString())
      console.log(`\nERFOLG: Bedrock-Anmeldung ok, Spielername: ${payload.extraData && payload.extraData.displayName}`)
      if (authName !== 'switch') console.log(`Diesen Weg dauerhaft nutzen:  bot-login ${id} ${authName}`)
    }
    process.exit(0)
  } catch (e) {
    const first = errors[0] || { label: 'unbekannt', full: String(e && e.message || e) }
    console.log(`\nURSACHE (erster Fehler, Schritt "${first.label}"):\n  ${first.full.split('\n').join('\n  ')}`)
    console.log(`\nHINWEIS: ${hint(first.full)}`)
    process.exit(1)
  }
})()
