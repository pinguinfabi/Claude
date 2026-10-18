'use strict'
// Anmeldewege: manche Konten lehnt Microsoft bei einem Weg ab und akzeptiert sie bei einem anderen
// (jeder Weg tritt gegenueber Microsoft als andere "App" auf). Auswahl per BOT_AUTH=<name>.
const { Titles } = require('prismarine-auth')

const PRESETS = {
  switch: { authTitle: Titles.MinecraftNintendoSwitch, deviceType: 'Nintendo', flow: 'live' }, // Standard
  java: { authTitle: Titles.MinecraftJava, deviceType: 'Win32', flow: 'sisu' },
  android: { authTitle: Titles.MinecraftAndroid, deviceType: 'Android', flow: 'live' },
  ios: { authTitle: Titles.MinecraftIOS, deviceType: 'iOS', flow: 'live' },
  xboxapp: { authTitle: Titles.XboxAppIOS, deviceType: 'iOS', flow: 'live' }
}

function preset (name) {
  const key = (name || process.env.BOT_AUTH || 'switch').toLowerCase()
  if (!PRESETS[key]) throw new Error(`Unbekannter Anmeldeweg "${key}" (moeglich: ${Object.keys(PRESETS).join(', ')})`)
  return { ...PRESETS[key] }
}

module.exports = { preset, PRESETS }
