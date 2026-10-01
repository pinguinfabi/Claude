# Neu in Deepforge 0.5.5

Beim Serverstart steht im Log `Deepforge 0.5.5 ready`. Ressourcenpaket unverändert (wie 0.5.2).

## Chat mit Rängen
Chatnachrichten sehen jetzt so aus: **[Rang-Tag] Name » Nachricht**.
- Mit Ressourcenpaket: der farbige Rang-Tag aus dem Netzwerk-Pack (ADMIN, MOD, VIP …), ohne Pack der Rang als
  fetter Text in Rangfarbe. Das wird **pro Leser** entschieden.
- Name in Rangfarbe; normale Spieler ohne Präfix mit grauem Namen und grauer Nachricht.
- Ränge wie in Tabliste/Nametags über `network.rank.<rang>` (siehe `docs/TAB-UND-AUTOLOGIN.md`).
- Abschaltbar mit `display.chat: false` in der `config.yml` (dann bleibt der Chat wie vorher).

## Endboss bleibt in seiner Halle
Der Dungeon-Boss kann seine Halle nicht mehr verlassen (weder in den Gang zurück noch in die Nische für
besiegte Spieler). Läuft er raus oder wird rausgeschubst, steht er sofort wieder am Rand der Halle.
Man kann ihn also nicht mehr aus sicherer Entfernung im Gang bekämpfen.

## Verkaufen mit Auswahl
- **Holz** (Holzfäller → „2 · Verarbeiten & Verkaufen“): Eiche, Birke und Fichte lassen sich **einzeln** verkaufen
  (jeweils Holz + Bretter dieser Sorte). „Alles Holz verkaufen“ gibt es weiterhin.
- **Schmiede / Lager:** neuer Knopf **„Nur Barren verkaufen“** (im Lager und im Schmelz-Fenster). Erze bleiben im
  Lager. Barren, die für die nächste Forschung oder den offenen Barrenauftrag gebraucht werden, bleiben liegen –
  die Nachricht sagt, wie viele reserviert wurden.
