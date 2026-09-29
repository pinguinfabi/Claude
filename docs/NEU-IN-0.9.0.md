# Neu in Deepforge 0.9.0 – 10 neue Minen, alle Minen neu gestaltet

Beim Serverstart steht im Log `Deepforge 0.9.0 ready`.

**Neues Ressourcenpaket** (SHA-1 `18352e9493db58ac5141605eef92f6d7a889a169`) mit Erz-Texturen und Monstern für die neuen Gebiete. Mit Self-Host oder leerem `sha1` passiert das automatisch. Sonst die neue ZIP hochladen und den SHA-1 in der `config.yml` eintragen.

**Einmaliger Neubau:** Beim ersten Start werden alle 17 Minen neu gebaut. Das dauert etwa 1,5 Minuten und passiert nur einmal. Im Log steht danach `Mines v4 ready … 17 cave networks complete`.
- Spielstände bleiben komplett erhalten: Geld, Lager, Erze, Bosse, Dungeon-Level.
- Alte Spielstände mit 7 Gebieten werden automatisch auf 17 erweitert.

## 10 neue Minen im Tiefen Schacht (Gebiet 8–17)
Die neuen Minen liegen in einem **zweiten Schacht** neben dem ersten, unter dem Wald. Du erreichst sie wie gewohnt über den **Aufzug** (Menü → Gebiete).

| Gebiet | Mine | Erz | Preis Erz / Barren ($) | Bohrer | Freischalten ($) | Höhlenform | Boss | Monster-Leben | Boss-Leben (normal) |
|---|---|---|---|---|---|---|---|---|---|
| 8 | **Kernschmelze** | Kernerz | 1.020 / 2.720 | 14 | 2.400.000 | Große Kluft | Kernkoloss | 2.013 | 127.304 |
| 9 | **Spiegelgrotten** | Spiegelerz | 1.730 / 4.620 | 16 | 5.400.000 | Hauptkaverne | Spiegelhexe | 2.416 | 149.361 |
| 10 | **Giftschlund** | Toxerz | 2.950 / 7.850 | 17 | 12.000.000 | Zwillingshallen | Giftmutter | 2.899 | 172.974 |
| 11 | **Sturmklüfte** | Sturmerz | 5.000 / 13.350 | 18 | 27.000.000 | Kammerlabyrinth | Sturmtitan | 3.479 | 198.144 |
| 12 | **Knochengrund** | Fossilerz | 8.500 / 22.700 | 20 | 61.000.000 | Große Kluft | Knochendrache | 4.175 | 224.870 |
| 13 | **Ätherhallen** | Äthererz | 14.500 / 38.600 | 22 | 138.000.000 | Hauptkaverne | Ätherwächter | 5.010 | 253.153 |
| 14 | **Schattenreich** | Schattenerz | 24.600 / 65.600 | 24 | 310.000.000 | Zwillingshallen | Schattenfürst | 6.012 | 282.993 |
| 15 | **Sternenbruch** | Sternerz | 41.800 / 111.500 | 26 | 700.000.000 | Kammerlabyrinth | Sternenkönig | 7.214 | 314.388 |
| 16 | **Urzeitkammern** | Urerz | 71.000 / 189.600 | 28 | 1.600.000.000 | Große Kluft | Urzeitbestie | 8.657 | 347.341 |
| 17 | **Weltenkern** | Kernkristall | 120.800 / 322.300 | 30 | 3.600.000.000 | Hauptkaverne | Weltenschlinger | 10.388 | 381.850 |

Zum Vergleich: Leerenbruch (Gebiet 7) hat 1.678 Monster-Leben und 106.803 Boss-Leben.

### Jede Mine sieht anders aus
| Mine | Aussehen |
|---|---|
| Kernschmelze | Lavabecken, Magma-Säulen, weinender Obsidian. **Hitze:** Der Bohrer überhitzt schneller. |
| Spiegelgrotten | weiße Glasspitzen, Quarz, getöntes Glas, hell wie ein Spiegelsaal |
| Giftschlund | Schlamm, Giftpfützen, Schleimgewächse, grünes Froschlicht. **Giftdämpfe:** ohne Schutztraining 12 verlierst du Leben. |
| Sturmklüfte | oxidierte Kupfermasten mit Blitzableitern |
| Knochengrund | riesige Fossil-Rippenbögen, Schädel im Sand |
| Ätherhallen | Purpur-Säulen, Chorusblüten, Endstein |
| Schattenreich | Seelenfeuer, schwarzes Glas, Sculk. **Schatten:** ohne Schutztraining 16 verlierst du Leben. |
| Sternenbruch | Amethyst-Geoden und leuchtende Sternensplitter |
| Urzeitkammern | Urwaldbäume, Moos, **Schnüffler-Eier** |
| Weltenkern | Obsidian-Spitzen, weinender Obsidian, ein **Leuchtfeuer** am Altar |

Die Monster der tiefen Minen haben eigene Farben und leuchtende Hörner. Jede Mine hat ihr eigenes animiertes Erz.

## Alle Minen neu gestaltet: 4 Höhlenformen
Auch die alten 7 Minen haben einen neuen Grundriss. Jede Mine nutzt eine von 4 Höhlenformen, jede zweite Runde **gespiegelt**. Keine Mine sieht aus wie ihre Nachbarin.

| Höhlenform | Aufbau | Minen |
|---|---|---|
| **Hauptkaverne** | große Mittelhalle mit Seitenkammern (die bekannte Form) | 1, 5 (gespiegelt), 9, 13 (gespiegelt), 17 |
| **Zwillingshallen** | zwei hohe Hallen links und rechts, von Felssäulen getragen | 2, 6 (gespiegelt), 10, 14 (gespiegelt) |
| **Kammerlabyrinth** | viele kleine Kammern an verwinkelten Stollen | 3, 7 (gespiegelt), 11, 15 (gespiegelt) |
| **Große Kluft** | eine riesige Spalte quer durch die Mine, mit Felspfeilern | 4, 8 (gespiegelt), 12, 16 (gespiegelt) |

- Die Deko (Kristalle, Pilze, Seen, Säulen …) passt sich an die Form an und steht in den Seitenkammern.
- **Gleich geblieben:**
  - Aufzug, Gleis zur Bosskammer, Bossarena und Galerie
  - Arbeiter und Fundkisten finden ihren Weg wie bisher
- Jedes Erz ist zu Fuß erreichbar. Das prüft ein automatischer Test für alle 17 Minen.
- Im Aufzug-Menü steht bei jeder Mine die Höhlenform.

## Balance der Tiefe
- **Monster:** In Gebiet 1–7 +60 % Leben und +45 % Schaden pro Gebiet (wie bisher). Im Tiefen Schacht **+20 % Leben und +14 % Schaden pro Gebiet**, sonst wäre das Ende unspielbar.
- **Ausrüstung aus den tiefen Minen** wird +12 % stärker pro Gebiet. Weltenkern-Beute ist etwa 12× so stark wie Eisenmine-Beute, Leerenbruch-Beute etwa 4×.
- **Bosse** wachsen weiter wie bisher. Der Weltenkern-Boss auf Albtraum hat etwa 3,6× so viel Leben wie der Leerenbruch-Boss.
- **Dungeons** gibt es jetzt für alle 17 Gebiete, mit +15 % Gegnerleben pro tiefem Gebiet.
- **Geld-Belohnungen** wachsen im Tiefen Schacht mit den Erzpreisen (×1,7 pro Gebiet). Das gilt für:
  - Jagden, Boss-Geld und Dungeon-Münzen
  - Tagesaufgaben, Champions und Fundkisten
  - Aufwertungskosten, Herstellen und Umschmieden
- **Ohne Ausrüstung sind die tiefen Minen tödlich.** Die Monster im Weltenkern töten ein frisches Profil in Sekunden.

## Bohrer bis Stufe 30
- Der Bohrer geht jetzt bis **Stufe 30** (vorher 20). Jede Stufe über 20 kostet **2,5× mehr** als sonst:
  - Stufe 20→21: 220.500 $
  - Stufe 25→26: 12,2 Mio. $
  - Stufe 29→30: 1,7 Mrd. $
- Jede Mine fühlt sich auf ihrer Bohrer-Stufe gleich schnell an wie der Leerenbruch auf Stufe 12.

## ☠ Urboss & Sternenstein jetzt im Weltenkern
- Der **Urboss** erwacht jetzt nur noch nach einem Albtraum-Sieg über den **Weltenschlinger (Weltenkern, Gebiet 17)**, wieder mit 1 %. Er ist ein zusätzlicher Kampf, kein Ersatz.
- Nur er lässt den **Sternenstein** fallen (2 %). Am Leerenbruch gibt es keine Sternensteine mehr.

## Neue Endgame-Ziele
Der Ziele-Knopf („Nächstes Ziel“) hat 5 neue Stufen. Sie bringen **Millionen**, dazu Staub:
1. Kernschmelze erschließen (Gebiet 8): 1 Mio. $
2. Knochengrund erschließen (Gebiet 12): 4 Mio. $
3. Weltenkern erschließen (Gebiet 17): 9 Mio. $
4. Weltenschlinger besiegen: 16 Mio. $
5. Weltenkern-Boss auf Albtraum besiegen: 25 Mio. $

Danach folgen wie bisher „Gegenstand über das Maximum schmieden“ (36 Mio. $) und „Urboss besiegen“ (49 Mio. $).

## Menüs
Aufzug, Lager, Schmelze, Arbeiter-Zuweisung, Fundkisten, Erzsammlung, Beutebuch und Jagden zeigen jetzt alle **17 Gebiete**.
- Jedes neue Gebiet hat einen eigenen **benannten Bossgegenstand** zum Herstellen, z. B. Kernspalter, Donnerspeer, Schattenklinge, Weltenklinge.
- Jedes neue Gebiet hat ein eigenes Monster-Material, z. B. Kernschlacke, Sturmfedern, Sternenstaub, Weltenkristalle.

## Admin-Testbefehl
- `/df admin gebiet <1–17>`:
  - schaltet bis zu diesem Gebiet frei (Bohrer und Bosse davor)
  - schickt dich direkt hin
