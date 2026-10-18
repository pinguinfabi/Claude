'use strict'
// Anmeldewege: manche Konten lehnt Microsoft bei einem Weg ab und akzeptiert sie bei einem anderen
// (jeder Weg tritt gegenueber Microsoft als andere "App" auf). Auswahl per BOT_AUTH=<name>.
const fs = require('fs')
const path = require('path')
const { Titles } = require('prismarine-auth')

// "prism": offizieller Geraete-Code-Weg (MSAL) mit der App-Kennung, die Prism Launcher selbst benutzt
// (fuer Java bewaehrt; fuer Bedrock experimentell).
// Die Kennung wird aus einem vorhandenen Prism-Konto gelesen (accounts.json: "msa-client-id").
function prismClientId () {
  if (process.env.BOT_PRISM_CLIENT_ID) return process.env.BOT_PRISM_CLIENT_ID.trim()
  const file = path.join(process.env.BOT_DIR || __dirname, 'prism-client-id.txt')
  try {
    const id = fs.readFileSync(file, 'utf8').trim()
    if (id) return id
  } catch (e) { /* unten melden */ }
  throw new Error('Prism-Client-ID fehlt (Datei prism-client-id.txt). update-setup.sh ausfuehren – es liest sie aus einem vorhandenen Prism-Konto.')
}

const PRESETS = {
  switch: () => ({ authTitle: Titles.MinecraftNintendoSwitch, deviceType: 'Nintendo', flow: 'live' }), // Standard
  java: () => ({ authTitle: Titles.MinecraftJava, deviceType: 'Win32', flow: 'sisu' }),
  android: () => ({ authTitle: Titles.MinecraftAndroid, deviceType: 'Android', flow: 'live' }),
  ios: () => ({ authTitle: Titles.MinecraftIOS, deviceType: 'iOS', flow: 'live' }),
  xboxapp: () => ({ authTitle: Titles.XboxAppIOS, deviceType: 'iOS', flow: 'live' }),
  // Bedrock braucht zusaetzlich eine Geraeteangabe (deviceOS); 7 = Windows 10 (per BOT_DEVICE_OS aenderbar)
  prism: () => ({ authTitle: prismClientId(), flow: 'msal', deviceOS: parseInt(process.env.BOT_DEVICE_OS || '7', 10) })
}

function preset (name) {
  const key = (name || process.env.BOT_AUTH || 'switch').toLowerCase()
  if (!PRESETS[key]) throw new Error(`Unbekannter Anmeldeweg "${key}" (moeglich: ${Object.keys(PRESETS).join(', ')})`)
  return PRESETS[key]()
}

module.exports = { preset, PRESETS }
