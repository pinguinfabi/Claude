# Neu in Deepforge 0.14.0 – Archäologie, Museum & Sammlungsbuch

Beim Serverstart steht im Log `Deepforge 0.14.0 ready`.

Zum Ressourcenpaket:
- Es gibt ein **neues Ressourcenpaket** mit 6 neuen Icons: Museum, Sammlungsbuch und vier Fund-Arten (Knochen, Kristall, altes Werkzeug, seltenes Relikt).
- Die SHA-1 steht in `resourcepack/pack.sha1` und ist in `config.yml` schon eingetragen.

## 🏺 Archäologie – Fundstücke beim Erzabbau
Jede Mine versteckt **4 Fundstücke**, 3 gewöhnliche und 1 **seltenes (★)**. Das sind **68 insgesamt**, jedes mit Namen und kleiner Geschichte. Beispiele:
- **Eisenmine:** Rostige Spitzhacke, Alte Grubenlampe, Versteinerter Farn, ★ Zwergenhelm
- **Knochengrund:** Saurierzahn, Rippenbogen, Versteinertes Ei, ★ Schädel des Urdrachen
- **Weltenkern:** Kernkristall-Nadel, Uralter Kompass, Weltgesteinsprobe, ★ Samen der Welt

Wie man sie findet:
- **Chance:** 0,8 % pro abgebautem Erzblock, also etwa jedes 125. Erz. Davon ist jeder 8. Fund (12 %) das seltene Stück der Mine, also etwa jedes 1.000. Erz.
- **Bei jedem Fund** kommt ein Titel („FUNDSTÜCK!“ bzw. „★ SELTENER FUND!“) mit Geräusch und Chat-Nachricht.

## 🏛 Museum & Sammlungsbuch
**Öffnen:** Hauptmenü → **Museum (unten rechts, Bücherregal)** oder `/df museum`.

Die beiden Ansichten:
- **Übersicht:** alle 17 Minen mit Stand (x/4). Vollständige Minen sind grün markiert.
- **Sammlungsbuch einer Mine:**
  - Die 4 Stücke der Mine; noch nie gefundene heißen **„???“**.
  - **Linksklick: dem Museum stiften.** Das bringt Geld im Wert von 40 Erzen der Mine (seltenes ×5) plus 5 Staub (selten 25).
  - **Rechtsklick: doppelte verkaufen** für den Wert von 10 Erzen pro Stück (selten ×5). Das erste Exemplar wird immer fürs Museum zurückgehalten.

### Museumsbonus (dauerhaft)
| | Bonus |
|---|---|
| jede vollständige Mine (alle 4 gestiftet) | +1 % Schaden und +1 % Erz- und Barrenwert |
| alle 17 Minen vollständig | noch einmal +5 %, zusammen **+22 %** |

- Der Bonus **bleibt auch nach einem Prestige**, genau wie die Sammlung.
- Er gilt auch für den Verkauf durch Händler-Arbeiter.

## 📖 Wiki
Die neue Seite **„Archäologie & Museum“** erklärt:
- die Fundchancen
- was Stiften und Verkaufen bringen
- den Museumsbonus

Sie listet für jede Mine alle Fundstücke, das seltene mit seiner Geschichte.

## Getestet
- **305 Unit-Tests** grün, 5 neue:
  - 68 eindeutige Fundstücke, 1 seltenes pro Mine
  - die Fundrate stimmt mit den angegebenen Chancen überein (200.000 Erzblöcke simuliert)
  - Stiften, Verkaufen, erstes Exemplar bleibt, Mine vollständig
  - voller Museumsbonus wirkt auf Schaden und Verkaufspreis
  - Wiki-Seite
- **Live mit Bot:**
  - Hauptmenü zeigt das Museum.
  - Die Übersicht zeigt „5 Fundstück(e) zum Stiften“.
  - Im Sammlungsbuch der Eisenmine wurden 4 Stücke gestiftet, danach kam „SAMMLUNG EISENMINE VOLLSTÄNDIG! Museumsbonus jetzt +1 %“.
  - Eine doppelte Spitzhacke wurde verkauft (+120 $).
  - „Zurück“ führt zur Übersicht, dort ist die Eisenmine grün.
  - Keine Fehler im Server-Log.
