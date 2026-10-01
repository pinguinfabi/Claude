# Neu in Deepforge 0.7.1 – Balance: tiefer = gefährlicher

Beim Serverstart steht im Log `Deepforge 0.7.1 ready`. Ressourcenpaket unverändert (wie 0.7.0).

## Monster: mehr Leben überall, tiefer viel mehr Schaden
Bisher wuchsen Leben und Schaden der Minenmonster nur ein kleines Stück pro Gebiet. Mit guter Dungeon-Ausrüstung konnte man deshalb durch alle Minen rushen. Jetzt wächst beides **pro Gebiet exponentiell**:

- **Normales Monster:** +55 % Leben pro Gebiet (schwere Monster ×1,8)
- **Monster-Schaden:** +40 % pro Gebiet
- **Boss-Schaden:** +30 % pro Gebiet

| Gebiet | Leben vorher → jetzt | Berührung | Monster-Angriff | Boss-Angriff |
|---|---|---|---|---|
| 1 Eisenmine | 44 → **65** | 2,0 → 2,5 | 3,0 → 3,5 | 5,5 → 5,5 |
| 2 Kristallhöhle | 74 → **101** | 2,7 → 3,5 | 3,5 → 4,9 | 6,7 → 7,2 |
| 3 Pilztiefen | 104 → **156** | 3,4 → 4,9 | 4,0 → 6,9 | 7,8 → 9,3 |
| 4 Versunkene Schächte | 134 → **242** | 4,1 → 6,9 | 4,5 → 9,6 | 8,9 → 12,1 |
| 5 Magmaschlucht | 164 → **375** | 4,8 → 9,6 | 5,0 → 13,4 | 10,1 → 15,7 |
| 6 Vergessene Ruinen | 194 → **582** | 5,5 → 13,4 | 5,5 → 18,8 | 11,2 → 20,4 |
| 7 Leerenbruch | 224 → **901** | 6,2 → 18,8 | 6,0 → 26,4 | 12,4 → 26,5 |

(Schaden vor deiner Rüstung. Der Rundumschlag und die Giftfelder der Bosse wachsen genauso.)

- **Minenbosse:**
  - Leben +15 % im ersten Gebiet bis +75 % im letzten.
- **Dungeons:**
  - Alle Gegner haben **+15 % Leben**.
  - Der Schaden wächst jetzt **+30 % pro Gebiet** und **+2,5 % pro Dungeon-Level** (vorher kaum). Auf Level 40 schlagen Gegner also etwa doppelt so hart zu wie auf Level 1.

## Grubenklinge: +4 % Schaden pro Stufe
Das Schwert-Upgrade gibt jetzt **+4 %** (statt 6 %) auf den gesamten Nahkampfschaden pro Stufe. Stufe 10 ergibt also +40 %.

## Heiltasche: Heilvorrat wächst mit einem Upgrade
- Jeder startet mit Platz für **3 Lebenssplitter**.
- Das neue Upgrade **„Heiltasche“** (Bergbau → Grund-Upgrades) gibt **+1 Platz pro Stufe bis 12**.
- Kosten der 9 Stufen: 600 / 2.400 / 5.400 / 9.600 / 15.000 / 21.600 / 29.400 / 38.400 / 48.600 $.
- Alle Anzeigen (Heilen-Knopf, Kristall, Seitenleiste, Charakter, Händlerin, Schnellkauf) zeigen den eigenen Vorrat, z. B. „2/5“.
- **Bestehende Spieler behalten ihre Splitter.** Wer mehr hat als sein neuer Vorrat, verliert nichts. Es kommen nur keine neuen dazu, bis man darunter ist oder die Heiltasche ausbaut.
- Belohnungen, die bei vollem Vorrat nicht mehr passen, verfallen wie bisher. Beim Tiefenpass werden sie zu Schmiedestaub.
