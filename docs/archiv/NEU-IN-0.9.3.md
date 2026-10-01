# Neu in Deepforge 0.9.3 – Tiefengang, Runen-Umbau, Upgrades bis 30, neue Texturen

Beim Serverstart steht im Log `Deepforge 0.9.3 ready`.

**Neues Ressourcenpaket** (SHA-1 `81c6ad24611d9e4a2cdaaa5dbc636cfd94dce9d3`) mit den neuen Icons. Mit Self-Host oder leerem `sha1` passiert das automatisch. Sonst die neue ZIP hochladen und den SHA-1 in der `config.yml` eintragen.

## ⬇ Tiefengang: der endlose Modus
- **Start:**
  - `/df tiefengang`
  - Hauptmenü → **Tiefengang** (Skulk-Katalysator, 5. Reihe)
  - Mit Party startet der Partyleiter für alle.
- **Freischalten:** einen beliebigen Dungeon gewinnen.
- **Ablauf:**
  - Eine große Arena, Ebene um Ebene nach unten.
  - Jede Ebene hat **2 Wellen**, ab Ebene 10 **3 Wellen**. **Jede 5. Ebene endet mit einem Boss.**
  - Zwischen den Ebenen gibt es einen kurzen Abstieg (Dunkelheit, Titel „EBENE 7“).
- **Alle starten gleich**, in der **Eisenmine**. Das ist fair für die Rangliste.
  - Alle 5 Ebenen geht es eine Mine tiefer, bis zum Weltenkern.
  - Die Arena bekommt dann das Gestein dieser Mine.
- **Es wird nie leichter:** Gegner-Level +2 pro Ebene, dazu **+6 % Leben und +4 % Schaden pro Ebene**. Jeder Lauf endet irgendwann, die Frage ist nur: wie tief?
- **Belohnung nach jeder Ebene**, sofort ausgezahlt:
  - Geld und Schmiedestaub
  - **Boss-Ebenen:** dreifaches Geld, ein Ausrüstungsteil („Tiefengang E10: …“) und 40 % Chance auf eine Rune
- **Ende:**
  - Fällt die ganze Gruppe, endet der Lauf in der **Abschlusshalle** mit Kamerafahrt, MVP und Statistik wie beim Dungeon, aber ohne Gewölbekisten.
  - `/df dungeon leave` beendet den Lauf jederzeit. Alles Verdiente bleibt.
- **Heiltränke:** Nachkaufen geht auch im Tiefengang nicht.

### Wochen-Rangliste
- `/df top` zeigt zwei neue Ranglisten: **„Tiefengang · diese Woche“** (tiefste Ebene der Woche) und **„Tiefengang · Rekord“**.
- Die Woche beginnt **montags um 0 Uhr** (deutsche Zeit) und startet für alle bei 0.
- Bei einem neuen Wochenrekord gibt es eine Meldung im Chat.
- Das Hauptmenü zeigt deinen Wochen- und Allzeitrekord.

## Runen: jetzt direkt auf den Grundwerten
**Bisher:**
- Die Kraftrune hat den Endschaden prozentual erhöht, statt zum Grundschaden zu zählen.
- Runen tauchten nirgends in den Werten auf.

**Jetzt addiert jede Rune direkt auf die Grundwerte:**

| Rune | pro Stufe (Eisenmine-Teil) | im Weltenkern-Teil |
|---|---|---|
| Kraftrune | +2 Grundschaden | +6,8 |
| Steinrune | +4 Rüstung | +13,6 |
| Lebensrune | +4 Leben | +13,6 |
| Windrune | +2,5 % Angriffstempo | gleich |
| Glücksrune | +1,5 % Krit-Chance | gleich |
| Tiefenrune | +3 % Abbautempo | gleich |

- **Kraft, Stein und Leben** wachsen mit dem Gebiet des Gegenstands: +15 % pro Gebiet, im Weltenkern also 3,4×.
  - Die Kraftrune zählt vor dem Grubenklingen-Bonus und wird davon mit verstärkt.
  - Pro Art zählen die **6 stärksten Runen**.
- Wind, Glück und Tiefe behalten ihre Obergrenzen (+20 % Tempo, +10 % Krit, +30 % Abbau).
- **Überall sichtbar:**
  - **Tooltip:** Die Werte enthalten die Runen, z. B. „Schaden 57 (inkl. +6 Rune)“. Jeder Sockel zeigt, was seine Rune bringt.
  - **Vergleich** „Gegenüber ausgerüstet“: Runen zählen mit.
  - **Charakter:** Eine Zeile „Runen (schon oben eingerechnet): +12 Grundschaden · +20 Rüstung …“
  - **Runenauswahl:** zeigt den genauen Wert im jeweiligen Gegenstand

### Runen sind jetzt deutlich seltener
| Quelle | vorher | jetzt |
|---|---|---|
| normales Minenmonster | 2 % | **0,3 %** |
| Talent „Runengespür“ | +1 % pro Rang | +0,2 % pro Rang |
| Champion (✦) | 1 sicher + 25 % eine zweite | **25 %** |
| Minenboss | 2 sicher | **35 %** |
| Dungeon-Sieg | 1 sicher | **30 %** |
| Urboss | 4 | 2 |

### Runen-Knopf
- **Hauptmenü → Runen** (Amethyst, 5. Reihe)
- **Beutel → Runen** (unten rechts)
- Im Kampf-Menü ist der Knopf wie bisher.

## Upgrades bis Stufe 30
- **Grubenklinge (Schwert)**, **Dampfbohrer** und **Schutztraining** gehen jetzt bis **Stufe 30**. Vorher stand im Menü fest „/ 20“.
- **Grubenklinge:** +0,7 Grundschaden und +4 % Nahkampfschaden pro Stufe, auf Stufe 30 also ×2,2.
- **Kosten:** Ab Stufe 20 kostet jede Stufe 2,5× mehr als die normale Kurve (Stufe 20→21 wie beim Bohrer).

## Neue Texturen
Eigene Pixel-Icons statt Vanilla-Gegenständen:
- **Runen:** 6 Runensteine und der Runenbeutel
- **Eier:** 5 Raritäten
- **Begleiter:** alle 7 Arten
- **Sternenstein**
- **Gilde:** Banner, Einladung, Ränge (Anführer, Offizier, Mitglied), die 5 Stützpunkt-Gebäude, Wochenaufträge
- **Meisterschaft:** Buch, die 3 Talentbäume, Talente (offen, gelernt, gesperrt, Schlüsseltalent)
- **Tiefenpass-Stufen**, Ausrüstungs-Sets, Beutel-Sortierung, „Seite auswählen“ und der Tiefengang

Ohne Ressourcenpaket siehst du wie bisher die normalen Minecraft-Gegenstände.

## Zu deiner Frage: Wie bekommt man ein Ei?
Eier sind sehr selten und fallen nur im Kampf:

| Quelle | Chance |
|---|---|
| Minenboss (jede Schwierigkeit) | **3 %** |
| Urboss | 9 % (dreifach) |
| Dungeon-Sieg | **1,5 %** pro Spieler |
| Champion (✦) in den Minen | **1 %** |
| normales Minenmonster | **0,02 %** (1 zu 5.000) |

Welche Rarität ein Ei hat, wird beim Fund ausgewürfelt:

| Rarität | Chance | Brutzeit am Camp |
|---|---|---|
| Ungewöhnlich | 55 % | 30 Min. |
| Selten | 28 % | 1 h |
| Episch | 12 % | 3 h |
| Legendär | 4,5 % | 6 h |
| Mythisch | 0,5 % | 12 h |

Du kannst bis zu 20 Eier aufbewahren. Ausbrüten geht im Menü **Begleiter & Brutstätte**, am Camp.
