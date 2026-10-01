# Neu in Deepforge 0.4.0 – Bossfights & Funke

Beim Serverstart steht im Log `Deepforge 0.4.0 ready`. **Plugin und Ressourcenpaket austauschen**
(das Paket enthält die neue Drohne; es liegt auch im Plugin und wird nach `plugins/Deepforge/` geschrieben).

## Neue Dungeon-Endbosse
Jedes Gebiet hat jetzt einen eigenen Endboss mit eigenem Angriffsstil:

| Gebiet | Boss | Spezialangriffe |
|---|---|---|
| 1 | Eisenkoloss | Schockwelle, Sprungangriff, Runensturm |
| 2 | Kristallkönigin | Splitterregen, Runensturm, Kreisstrahl |
| 3 | Sporenmutter | Sog, Splitterregen, Sprungangriff |
| 4 | Tiefenwächter | Schockwelle, Runensturm, Sog |
| 5 | Glutfürst | Kreisstrahl, Sprungangriff, Splitterregen |
| 6 | Reliktwächter | Runensturm, Schockwelle, Kreisstrahl |
| 7 | Leerenherz | Sog, Kreisstrahl, Sprungangriff |

Dazu kennt jeder Boss **Stampfer** (roter Kreis) und **Runenstrahl** (Linie).

### Angriffe, denen man wirklich ausweichen muss
Jeder Angriff wird angekündigt: Titel mit Tipp, Ton und Partikel-Umriss, der sich bis zum Einschlag füllt.

- **Schockwelle** – ein Ring breitet sich aus. Durch die grüne Lücke laufen, **springen** oder rollen.
- **Sprungangriff** – der Boss springt auf die markierte Stelle und schleudert alle weg.
- **Kreisstrahl** – ein Flammenstrahl dreht sich einmal um den Boss. Vor ihm herlaufen oder durchrollen.
- **Splitterregen** – viele kleine Einschläge rund um die Spieler.
- **Sog** – zieht alle zum Boss und explodiert dann. Dagegen anlaufen!
- **Runensturm** – trifft die ganze Arena außer dem grünen Feld (für Gruppen größer).
- Die **Ausweichrolle** (Sneak + Rechtsklick mit der Waffe) macht kurz unverwundbar.

### Drei Phasen
- Bei 66 % und 33 % Leben wechselt der Boss die Phase: kurzer Schutzschild (IMMUN), Brüllen, Rückstoß.
- Mit jeder Phase kommt ein neuer Spezialangriff dazu, die Warnzeiten werden kürzer.
- **Phase 3:** große Angriffe kommen zusammen mit einem Stampfer auf einen anderen Spieler.
- Nach 4 Minuten wird der Boss **WÜTEND**: schneller und härter.

### Belohnung für gutes Spielen
- Nach jedem großen Angriff ist der Boss 3 Sekunden **erschöpft**: „SCHWACHSTELLE!“ = **+75 % Schaden**.
- **MAKELLOS:** Wer von keinem großen Bossangriff getroffen wurde, bekommt nach dem Sieg **+25 % Dungeon-Geld** extra.
- Boss-Leiste oben zeigt Name, Phase, IMMUN / SCHWACHSTELLE / WÜTEND.
- Admins können im Dungeon mit `/df admin boss` direkt zum Endboss springen (zum Testen).

## Funke – deine Dampfdrohne (`/df drohne`)
Eine kleine Drohne (eigenes 3D-Modell), die dir über der rechten Schulter folgt – im Bergwerk und im Gewölbe.
Nur du siehst deine Drohne.

- **Bauen:** 5.000 $ im Menü „Funke“ (Hauptmenü oder `/df drohne`).
- **Verbessern** bis Stufe 10 mit Geld und Schmiedestaub (ab Stufe 5 auch Relikte).
- **Module** (jederzeit kostenlos wechselbar):
  - **Sammler** – findet im Bergwerk regelmäßig Erz für deinen Rucksack.
  - **Geschütz** – schießt Dampfbolzen auf Gegner in deiner Nähe (Monster, Bosse, Dungeon).
  - **Sanitäter** – heilt dich, wenn dein Leben unter 70 % fällt.
- **Immer dabei:** Funke piept und zeigt in Richtung einer reichen Ader und warnt dich kurz vor einem Bossangriff,
  wenn du im Einschlagsbereich stehst („⚠ Funke: Ausweichen!“).
- **Aussehen:** Messing, Kupfer (Stufe 3), Kristall (Stufe 6), Glut (Stufe 10).
- „Funke ausruhen lassen“ blendet die Drohne aus.
- Ohne Ressourcenpaket erscheint Funke als kleine Laterne.
