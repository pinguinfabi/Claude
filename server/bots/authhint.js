'use strict'
// Erkennt Anmeldefehler von prismarine-auth (die Bibliothek schreibt sie nur per console.debug und
// fragt dann bis zu 15 Minuten weiter nach) und uebersetzt sie in einen verstaendlichen Hinweis.

function hint (text) {
  const t = String(text).toLowerCase()
  if (t.includes('user could not be authenticated') || t.includes('user interaction is required') || t.includes('grant the client application')) {
    return 'Microsoft hat die Anmeldung dieses Kontos abgelehnt. Haeufige Gruende: (1) Kinder-/Jugendkonto ohne Freigabe in der Microsoft-Familiengruppe, ' +
      '(2) das Konto verlangt eine Sicherheitspruefung (Telefon/E-Mail bestaetigen), (3) beim Anmelden wurde die Frage "Zugriff erlauben?" nicht mit JA bestaetigt, ' +
      '(4) es ist ein Arbeits-/Schulkonto statt eines privaten Microsoft-Kontos. Bitte in einem NEUEN Browserfenster (privat) auf https://account.microsoft.com mit diesem Konto ' +
      'anmelden, alle Aufforderungen erledigen, dann auf https://www.minecraft.net/login und https://www.xbox.com anmelden und danach "bot-auth-check <bot> --neu" wiederholen.'
  }
  if (t.includes('authorization_declined') || t.includes('declined')) {
    return 'Die Anmeldung wurde im Browser abgelehnt/abgebrochen. Beim Anmelden JA/Zulassen waehlen.'
  }
  if (t.includes('expired_token') || t.includes('timed out') || t.includes('expired')) {
    return 'Der Code ist abgelaufen. Neu starten und den Code sofort im Browser eingeben.'
  }
  if (t.includes('2148916233') || t.includes('does not have an xbox')) {
    return 'Das Konto hat KEIN Xbox-Profil. Auf https://www.xbox.com anmelden und einen Gamertag anlegen, danach neu versuchen.'
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
  if (t.includes('not found') || t.includes('own minecraft') || t.includes('profile')) {
    return 'Das Konto besitzt Minecraft: Java Edition nicht (oder hat noch keinen Profilnamen). Unter minecraft.net/profile pruefen.'
  }
  if (t.includes('device_code') && t.includes('already been used')) {
    return 'Der Geraete-Code wurde bereits verbraucht (Folgefehler eines vorherigen Fehlers).'
  }
  return 'Unbekannter Anmeldefehler – den Text oben bitte weitergeben.'
}

const AUTH_RE = /Failed to acquire authorization code|invalid_grant|Authentication failed|Xbox Live authentication failed/i

// Ruft onError genau EINMAL beim ersten Anmeldefehler auf, alles andere geht normal an console.debug.
function watchAuthErrors (onError) {
  const original = console.debug.bind(console)
  let fired = false
  console.debug = (...args) => {
    const text = args.map(a => (a && a.message) ? a.message : String(a)).join(' ')
    if (AUTH_RE.test(text)) {
      if (!fired) {
        fired = true
        try { onError(text) } catch (e) { /* egal */ }
      }
      return
    }
    original(...args)
  }
}

module.exports = { hint, watchAuthErrors }
