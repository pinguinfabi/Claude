# Neu in Deepforge 0.2.1

Beim Serverstart steht im Log `Deepforge 0.2.1 ready`. Plugin **und** Ressourcenpaket austauschen:
`plugins/Deepforge.jar` ersetzen und die neue `resourcepack/Deepforge-ResourcePack.zip` an alle Spieler verteilen
(bzw. auf dem Webspace ersetzen und `resource-pack.sha1` in `plugins/Deepforge/config.yml` auf den Wert aus
`resourcepack/pack.sha1` setzen).

## Waffen- und Werkzeugmodelle
- Schwert, Dolch, Hammer, Speer, Armbrust, Grubenklinge und Dampfbohrer sind neu modelliert.
- Sie liegen wie Vanilla-Schwerter in der Hand: in der Ich-Perspektive unten rechts statt über dem halben Bildschirm,
  in der Außenansicht nach vorne gerichtet statt flach am Arm.
- Die Armbrust wird wie die Vanilla-Armbrust gehalten.
- Neue Materialien: Stahlklinge mit Schneide, Messingbeschläge, Lederwicklung, Holzschaft und leuchtender Edelstein.
- Die Boss-Trophäen (Unikate) verwenden dieselben Modelle in den Farben ihres Gebiets.

## Weitere Grafiken
- Alle Symbole (Münze, Uhr, Scanner, Arbeiter, Schild, Brennstoff, Handbuch, Relikt, Erze) haben Umrisse, Licht und Schatten.
- Ausrüstungssymbole (Helm, Brustpanzer, Beinschutz, Stiefel, Ringe, Amulett, Schild) sind neu gezeichnet.
- Monster haben Panzerplatten mit leuchtenden Rissen statt Rauschen; Texturen werden nicht mehr gestreckt.
  Beim Treffer bleibt die Oberfläche im roten Aufblitzen erkennbar.
- Kupfer- und Leuchttexturen der Maschinen sowie der Heilkristall wurden überarbeitet.

## Spielgefühl und Fehlerbehebungen
- **Doppelklick in Menüs kauft nicht mehr doppelt.** Ein Doppelklick (oder schnelles Mehrfachklicken) auf
  Verbessern, Kaufen, Reroll usw. wird nur einmal ausgeführt.
- **Hinweis beim Abbauen:** Wer auf ein Erz schlägt und es nicht abbauen kann, sieht jetzt den Grund:
  kein Bohrer in der Hand, Gebiet gesperrt, Bohrer-Stufe zu niedrig, Rucksack voll oder Bohrer überhitzt.
  Vorher passierte einfach nichts.
- **Neue Aktionsleiste beim Bergbau:** Geld mit Tausenderpunkten, Rucksack (rot mit „VOLL“) und eine
  Hitzeanzeige ▮▮▮▯▯ in Grün/Gelb/Rot.
- **Beute beim Monsterkill sichtbar:** „Besiegt · +X $ · +Y Monsterteile“ in der Aktionsleiste.
- Befehlsfehler zeigen den echten Grund (z. B. „Nur der Partyleiter kann starten.“) statt nur „Ungültige Eingabe“;
  Tippfehler bei Zahlen melden „Bitte eine ganze Zahl angeben.“
