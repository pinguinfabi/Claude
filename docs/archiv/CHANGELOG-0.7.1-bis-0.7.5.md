# Deepforge – Changelog 0.7.1 bis 0.7.5

Aktuelle Version: **0.7.5**. Beim Serverstart steht im Log `Deepforge 0.7.5 ready`.
Das **Ressourcenpaket ist seit 0.7.0 unverändert** (SHA-1 `27421da96dfae38216b9d6032fd8afd0262cd0ef`). Es reicht, die neue `Deepforge.jar` einzuspielen.

## Kurzüberblick
| Version | Inhalt |
|---|---|
| 0.7.1 | Balance: Monster skalieren stark mit der Tiefe, Schwert +4 %/Stufe, Heiltasche (Heilvorrat 3 → 12) |
| 0.7.2 | Ausrüstungs-Sets: „Auf aktiv stellen“, Automatik entfernt |
| 0.7.3 | Ausrüstungs-Sets bearbeiten, einzelne Teile entfernen, Sets leeren |
| 0.7.4 | Krit-Reroll nach 3 Versuchen „UNBEZAHLBAR“ statt Millionen-Preis |
| 0.7.5 | Beutel: Shift-Klick-Mehrfachauswahl, alle ausgewählten zerlegen/verkaufen |

---

## 0.7.1 – Balance: tiefer = gefährlicher

### Monster: mehr Leben überall, tiefer viel mehr Schaden
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

(Schaden vor deiner Rüstung. Rundumschlag und Giftfelder der Bosse wachsen ebenfalls um +30 % pro Gebiet.)

- **Minenbosse:** Leben +15 % im ersten Gebiet bis +75 % im letzten.
- **Dungeons:**
  - Alle Gegner haben **+15 % Leben**.
  - Der Schaden wächst **+30 % pro Gebiet** und **+2,5 % pro Dungeon-Level** (vorher kaum). Auf Level 40 schlagen Gegner also etwa doppelt so hart zu wie auf Level 1.

### Grubenklinge: +4 % Schaden pro Stufe
Das Schwert-Upgrade gibt **+4 %** (statt 6 % in 0.7.0) auf den gesamten Nahkampfschaden pro Stufe. Stufe 10 ergibt also +40 %.

### Heiltasche: Heilvorrat wächst mit einem Upgrade
- Jeder startet mit Platz für **3 Lebenssplitter**.
- Das neue Upgrade **„Heiltasche“** (Bergbau → Grund-Upgrades) gibt **+1 Platz pro Stufe bis 12**.
- Kosten der 9 Stufen: 600 / 2.400 / 5.400 / 9.600 / 15.000 / 21.600 / 29.400 / 38.400 / 48.600 $.
- Alle Anzeigen (Heilen-Knopf, Kristall, Seitenleiste, Charakter, Händlerin, Schnellkauf) zeigen den eigenen Vorrat, z. B. „2/5“.
- **Bestehende Spieler behalten ihre Splitter.** Wer mehr hat als sein neuer Vorrat, verliert nichts. Es kommen nur keine neuen dazu, bis man darunter ist oder die Heiltasche ausbaut.
- Belohnungen, die bei vollem Vorrat nicht mehr passen, verfallen wie bisher. Beim Tiefenpass werden sie zu Schmiedestaub.

---

## 0.7.2 – Sets: „Auf aktiv stellen“ statt Automatik
- Der **automatische Set-Wechsel ist entfernt**. Beim Dungeon-Start und danach wird nichts mehr von selbst umgezogen.
- Unter jedem Set gibt es den Knopf **„Auf aktiv stellen“** (Smaragd). Damit legst du das Set an.
- Das gerade getragene Set zeigt **„✔ Aktiv“** (grüner Farbstoff), ein leeres Set **„Noch leer“**.
- Alte Automatik-Einstellungen werden beim Laden ignoriert. Es geht nichts verloren.

---

## 0.7.3 – Sets bearbeiten, Teile entfernen, Sets leeren
Unter Charakter → **Ausrüstungs-Sets** (oder `/df sets`):

- **Set bearbeiten:** Klick auf das Set-Symbol öffnet den Editor mit allen 10 Plätzen (Waffe, Nebenhand, Helm, …).
  - **Platz anklicken** zeigt alle passenden Teile aus deinem Beutel (die besten zuerst). Ein Klick übernimmt das Teil ins Set und ersetzt das alte.
  - **Roter Farbstoff unter einem Platz** nimmt das Teil **aus dem Set**. Das Teil selbst bleibt im Beutel bzw. angelegt.
  - **Smaragd oben rechts:** Set auf aktiv stellen.
- **Set leeren:** Barriere über jedem Set oder `/df sets leeren <1-4>`. Der Name bleibt und die Ausrüstung bleibt angelegt. Nur das Set ist danach leer, und der Verkaufsschutz für diese Teile entfällt.

### Aufbau der Set-Übersicht
| Reihe | Knopf | Wirkung |
|---|---|---|
| oben | Barriere | Set leeren |
| Mitte | Set-Symbol | Set bearbeiten |
| darunter | Buch | aktuelle Ausrüstung als Set speichern |
| unten | Smaragd | Set auf aktiv stellen |

### Alle Set-Befehle
| Befehl | Wirkung |
|---|---|
| `/df sets` | Übersicht öffnen |
| `/df sets 2` oder `/df sets Mining` | Set auf aktiv stellen |
| `/df sets speichern 2` | aktuelle Ausrüstung als Set 2 speichern |
| `/df sets leeren 2` | Set 2 leeren |
| `/df sets name 2 Bossjagd` | Set 2 umbenennen |

Teile, die in einem Set stecken, sind vor Verkaufen, Zerlegen und der Set-Schmiede geschützt.

---

## 0.7.4 – Krit-Reroll: nach 3 Versuchen „UNBEZAHLBAR“
- Krit-Chance und Krit-Schaden lassen sich je Gegenstand **3-mal günstig** neu schmieden (500 / 1.500 / 4.500 $ × Gebiet, dazu 5 / 10 / 20 Staub).
- Danach steht im Menü **„UNBEZAHLBAR“** statt einer Millionen-Summe. Der Knopf ist gesperrt, und der Wert bleibt endgültig so, auch mit beliebig viel Geld.
- Krit-Chance und Krit-Schaden zählen getrennt (je 3 Versuche).

---

## 0.7.5 – Beutel: mehrere Gegenstände auf einmal zerlegen oder verkaufen
Im Beutel (`/df loot`):

- **Shift + Klick** auf einen Gegenstand **wählt ihn aus**. Er wird zur grünen Scheibe mit „✔“. Nochmal Shift-Klick wählt ihn ab. Ein normaler Klick öffnet wie bisher die Detailseite.
- **Ganze Seite auswählen** (Limettenfarbstoff, unten links): wählt alle ungeschützten Teile der Seite.
- **Ausgewählte zerlegen** (Trichter) zeigt vorher, wie viel Schmiedestaub es gibt.
- **Ausgewählte verkaufen** (Goldbarren) zeigt vorher den Erlös.
- **Sicherheitsabfrage:** Der erste Klick fragt „WIRKLICH … ? Nochmal klicken“. Erst der zweite Klick innerhalb von 5 Sekunden führt es aus.
- **Auswahl aufheben** (Barriere).
- **Geschützte Teile werden nie gelöscht:** Favoriten, angelegte Teile und Teile in einem Ausrüstungs-Set lassen sich nicht auswählen und werden übersprungen.
- Die Auswahl bleibt beim Blättern zwischen den Seiten erhalten.
