# Gemeinsame Welt

Alle Spieler teilen sich **ein Lager und dieselben sieben Minen**. Kämpfe und persönlicher Fortschritt bleiben trotzdem pro Spieler.

## Was geteilt wird

- Spawn, Lager, Aufzug, Stationen, Holzfäller-Gebiet und alle Minen.
- Erzadern: Wer einen Block zuerst abbaut, bekommt ihn. Er wächst nach `mining.respawn-seconds` (Standard 25 s) nach. Doppelte Beute für denselben Block gibt es nicht.
- Arbeiter-NPCs aller Spieler laufen in denselben Minen.

## Was persönlich bleibt

- **Gegner und Bosse:** Jeder hat seine eigenen. Nur der Besitzer sieht sie, kann sie treffen und wird von ihnen getroffen. Andere Spieler laufen durch sie hindurch. Das gilt auch für Warnkreise, Treffereffekte, Lebensanzeigen und Beute-Anzeigen.
- **Bosskampf:** Jeder startet seinen eigenen Boss. Mehrere Spieler können gleichzeitig in derselben Arena gegen ihren jeweils eigenen Boss kämpfen.
- **Lagerschilder und Deko mit Fortschritt:** Kapazität, Ofenstufe, Kisten, Arbeiterzahl, Trophäen, Werkstattrang, Holzfäller-Freischaltungen und die NPCs Jorin und Mira sieht jeder mit seinen eigenen Werten.
- **Fundkisten (Erkundung):** nur für den jeweiligen Spieler sichtbar und anklickbar.
- Geld, Rucksack, Lager, Ausrüstung und alle übrigen Spielerdaten.

## Party und Dungeons

`/df party` bleibt für die Runengewölbe. Dungeons sind weiterhin eigene Instanzen und skalieren mit der Gruppe: Leben +85 % pro weiterem Spieler. Verlässt jemand während des Laufs die Gruppe oder verliert die Verbindung, werden die laufenden Gegner sofort schwächer, bei Rückkehr wieder stärker.

## Einstellungen (`config.yml`, Abschnitt `game`)

| Schlüssel | Standard | Bedeutung |
|---|---|---|
| `shared-world` | `true` | `false` stellt das alte Modell wieder her: jeder Spieler hat ein eigenes Lager, und Partymitglieder teilen sich das Lager des Gründers. |
| `shared-plot` | `0` | Parzelle, die als gemeinsames Lager dient. `0` ist die erste jemals angelegte Parzelle. |

Bestehende Einzel-Lager bleiben in der Welt erhalten. Beim Zurückschalten auf `shared-world: false` ist alles wieder da.
