'use strict'
// Diagnose: findet heraus, bei welchem Schritt die Microsoft-/Xbox-Anmeldung eines Kontos scheitert.
//   node auth-check.js <j1..j5|b1..b5>
const fs = require('fs')
const path = require('path')
const { Authflow, Titles } = require('prismarine-auth')

const id = process.argv[2]
if (!/^[jb][1-9]\d*$/.test(id || '')) {
  console.error('Aufruf: node auth-check.js <j1..j5 | b1..b5>')
  process.exit(2)
}
const isJava = id[0] === 'j'
const dir = path.join(process.env.BOT_DIR || __dirname, 'profiles', id)
fs.mkdirSync(dir, { recursive: true })

const errors = []
const flow = new Authflow(id, dir, { authTitle: Titles.MinecraftNintendoSwitch, deviceType: 'Nintendo', flow: 'live' }, data => {
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

function hint (text) {
  const t = text.toLowerCase()
  if (t.includes('2148916233') || t.includes('does not have an xbox') || t.includes('create') && t.includes('xbox')) {
    return 'Das Microsoft-Konto hat KEIN Xbox-Profil. Einmal auf https://www.xbox.com anmelden und einen Gamertag anlegen, danach hier neu versuchen.'
  }
  if (t.includes('2148916238') || t.includes('under 18') || t.includes('child')) {
    return 'Kinder-Konto: Es muss in einer Microsoft-Familiengruppe von einem Erwachsenen freigegeben werden (account.microsoft.com/family).'
  }
  if (t.includes('2148916235') || t.includes('banned') || t.includes('country')) {
    return 'Xbox Live ist fuer die Region dieses Kontos gesperrt oder das Konto ist gesperrt.'
  }
  if (t.includes('2148916236') || t.includes('2148916237') || t.includes('adult')) {
    return 'Das Konto braucht eine Alters-/Erwachsenen-Verifizierung bei Xbox.'
  }
  if (t.includes('not found') || t.includes('profile') || t.includes('own minecraft')) {
    return 'Das Konto besitzt Minecraft: Java Edition nicht (oder hat noch keinen Profilnamen). Mit dem Launcher einmal pruefen: minecraft.net/profile.'
  }
  if (t.includes('invalid_grant') || t.includes('device_code')) {
    return 'Der Geraete-Code wurde nicht rechtzeitig/richtig bestaetigt. Mit  --neu  noch einmal starten und den Code SOFORT eingeben.'
  }
  return 'Unbekannter Fehler – den obigen Text bitte weitergeben.'
}

console.log(`Pruefe Konto fuer Bot ${id} (${isJava ? 'Java' : 'Bedrock'}) ...`)
;(async () => {
  try {
    if (isJava) {
      const r = await flow.getMinecraftJavaToken({ fetchProfile: true })
      if (!r.profile || r.profile.error) throw new Error('Kein Minecraft-Java-Profil – besitzt das Konto Minecraft Java? ' + JSON.stringify(r.profile || {}))
      console.log(`\nERFOLG: Anmeldung ok, Spielername: ${r.profile.name}`)
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
