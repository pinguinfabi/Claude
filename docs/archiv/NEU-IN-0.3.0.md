# Neu in Deepforge 0.3.0

Beim Serverstart steht im Log `Deepforge 0.3.0 ready`. **Plugin und Ressourcenpaket austauschen**
(neue `plugins/Deepforge.jar`, neue `resourcepack/Deepforge-ResourcePack.zip` an alle Spieler; bei einer URL
`resource-pack.sha1` auf den Wert aus `resourcepack/pack.sha1` setzen). Neue Einstellungen (`events:` und `game.timezone`) gelten auch ohne Eintrag mit Standardwerten; die mitgelieferte `config.yml` enthält sie bereits.

## Spiel-HUD statt Minecraft-Text
Mit geladenem Ressourcenpaket (`/df pack local` bzw. automatisch per URL) zeigt die Aktionsleiste ein eigenes HUD:
- **Bergbau:** Münze + Geld (ab 100.000 kompakt, z. B. 1.23M$), Rucksack-Balken mit Füllstand (grün → gelb → rot, „VOLL“),
  Hitze-Balken mit Prozent, bei einer reichen Ader ein Edelstein mit Entfernung und Richtungspfeil.
- **Kampf** (Waffe in der Hand oder im Kampf): Herz + Lebensbalken, Blitz + Ausdauerbalken, Stern für die Fähigkeit
  („BEREIT“ oder Sekunden), Heilkristall mit Splittern und Abklingzeit, Schwert mit Kombo-Zähler.
- Eigene Pixelschrift, Symbole, segmentierte Balken und dunkle Panels mit goldener Kante – alles im Ressourcenpaket.
- Aktualisiert sich viermal pro Sekunde statt einmal.
- Die Seitenleiste bekommt vor jedem Wert ein Symbol und zeigt jetzt auch die Tagesaufträge.
- Ohne Ressourcenpaket bleibt die bisherige Textanzeige.

## Tagesaufträge (`/df daily`)
- Jeden Tag (Mitternacht, Zeitzone `game.timezone`, Standard Europe/Berlin) drei Aufgaben aus: Erz abbauen, Monster besiegen,
  Bäume fällen, Erz einlagern, Barren schmelzen, Barren verkaufen, Ausweichen, Gewölbe bezwingen.
  Es kommen nur Aufgaben, die du schon machen kannst; die Ziele wachsen mit deinem Gebiet.
- Je Aufgabe: 250 $ × Gebiet + 1 Schmiedestaub. Alle drei: Bonusgeld, 2 Staub, 1 Relikt, 1 Unterlage.
- **Serie:** Wer an aufeinanderfolgenden Tagen alle drei schafft, bekommt mehr Bonusgeld (bis Tag 7).
- Erreichbar über Hauptmenü, „Aufträge & Abenteuer“ oder `/df daily`. Eine Meldung erscheint, sobald eine Aufgabe erfüllt ist.

## Reiche Adern (Minen-Ereignis)
- Alle 4 Minuten wird in einer belegten Minenebene eine zufällige Erzader zur **reichen Ader**:
  goldene Funken und eine Lichtsäule, Ansage im Chat, Pfeil und Entfernung im HUD.
- Wer sie zuerst abbaut, bekommt **4× Erz** und Schmiedestaub. Nach 2 Minuten versiegt sie.
- Einstellbar: `events.rich-vein-seconds` und `events.rich-vein-duration`.

## Kampf-Kombo
- Treffer im Abstand von höchstens 2 Sekunden bauen eine Kombo auf: +3 % Schaden pro Treffer, maximal +30 % ab dem 11. Treffer.
- Wirst du getroffen, ist die Kombo weg. Klang bei x5 und x11, Anzeige im HUD. Die beste Kombo zählt für die Rangliste.

## Rangliste (`/df top`)
Acht Ranglisten mit den Top 5 und deinem Platz: Umsatz, Erz, Gegner, Bosssiege, Dungeon-Siege, Bäume, längste Tagesserie, beste Kombo.
