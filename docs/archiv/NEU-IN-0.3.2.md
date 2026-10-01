# Neu in Deepforge 0.3.2

Beim Serverstart steht im Log `Deepforge 0.3.2 ready`. Das Ressourcenpaket ist dasselbe wie in 0.3.0/0.3.1.

## Kästchen statt Symbolen? Altes Ressourcenpaket!
Sieht man im HUD oder in der Seitenleiste nur Kästchen (□□□) oder hält man noch das alte, große Schwert,
ist ein **altes** Deepforge-Ressourcenpaket aktiv. Lösung:
1. In Minecraft unter *Optionen → Ressourcenpakete* das alte Deepforge-Paket entfernen.
2. Die neue `Deepforge-ResourcePack.zip` in den Ordner `.minecraft/resourcepacks` legen, aktivieren und ganz nach oben schieben.
3. Im Spiel `/df pack local` und beim HUD-Test **[Ja → Spiel-HUD]** anklicken.

Seit 0.3.2 passiert das nicht mehr unbemerkt:
- Das Spiel-HUD und die Symbole in der Seitenleiste erscheinen **automatisch nur**, wenn der Server das aktuelle Paket
  selbst geschickt hat und der Client es geladen hat. Sonst bleibt die Textanzeige – keine Kästchen.
- `/df hud spiel` erzwingt das Spiel-HUD (lokales, aktuelles Paket), `/df hud text` die Textanzeige, `/df hud auto` den Standard.
- `/df pack local` zeigt einen HUD-Test mit Münze, Herz und Stern und zwei Knöpfen zur Auswahl.

## Ressourcenpaket steckt im Plugin
- Das passende Paket ist in der `Deepforge.jar` enthalten und wird bei jedem Start nach
  `plugins/Deepforge/Deepforge-ResourcePack.zip` geschrieben – dort liegt immer die richtige Version.
- **Automatische Verteilung (empfohlen):** In `plugins/Deepforge/config.yml` setzen:
  ```yaml
  resource-pack:
    self-host:
      enabled: true
      port: 8765
  ```
  Dann bekommt jeder Spieler beim Betreten das passende Paket direkt vom Server (Minecraft fragt einmal nach).
  Der Port muss von außen erreichbar sein (beim Hoster freigeben bzw. im Router weiterleiten).
  Adresse: automatisch die, mit der sich der Spieler verbunden hat; sonst `public-address` setzen.
- Bei eigener URL darf `resource-pack.sha1` leer bleiben – dann gilt die Prüfsumme des mitgelieferten Pakets.

## Seitenleiste aufgeräumt
Titel „Pinguin Netzwerk · Deepforge“ und die Zeile „DEIN FORTSCHRITT“ sind weg; die Werte beginnen direkt mit Geld.
