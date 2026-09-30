# Neu in Deepforge 0.16.2 – HUD flackert nicht mehr

Beim Serverstart steht im Log `Deepforge 0.16.2 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.16.1).

## ⚠ Zum Fehler im Server-Log (`Health value … Drones.behave`)
Im Log steht `Task #125 for Deepforge v0.16.0`: Auf deinem Server lief noch **0.16.0**. Der Fehler ist seit 0.16.1 behoben. Mit diesem Jar ist er ebenfalls weg, es muss nur eingespielt werden.

## 🖥 HUD-Flackern beim Erzabbau (dein Hinweis)
Zwei Ursachen, beide behoben:

1. **Meldungen haben das HUD kurz ersetzt.**
   - Meldungen wie „BONUS · +2 Eisenerz“, „Bohrer heiß“ oder „Dampfbohrer in die Hand nehmen“ gingen erst **allein** in die Aktionsleiste. Das HUD verschwand dadurch bis zum nächsten Takt und kam dann mit der Meldung darüber zurück.
   - Jetzt wird bei jeder Meldung sofort das komplette HUD mit der Meldung darüber gezeichnet.
   - Umgestellt sind auch die Meldungen, die bisher gar nicht über das HUD-System liefen:
     - Erz-Bonus
     - Glanzmonster-Countdown
     - Wächter-Warnungen im Dungeon: Schild, Zwillinge, Spiegel, Kette, Dornen, Blocken
2. **Das HUD ist seitlich gesprungen.**
   - Minecraft zentriert die Aktionsleiste. Wurde ein Wert breiter, z. B. Hitze „9%“ → „10%“ oder Rucksack „9/100“ → „10/100“, rutschte das ganze HUD ein paar Pixel zur Seite. Beim Abbauen passiert das ständig.
   - Jetzt haben alle Werte eine feste Breite: Leben, Rucksack, Hitze, Ader-Entfernung, Fähigkeit, Heilung und Combo.
   - Auch die Breite der Meldungen wurde vorher nur geschätzt (bei „–“ oder „⚡“ bis zu 5 Pixel daneben). Jetzt wird sie mit den **exakten Minecraft-Zeichenbreiten** gerechnet. Die fehlenden Symbole habe ich aus Minecrafts eigener Ersatzschrift (Unifont) ausgelesen.

## Getestet
- **319 Unit-Tests** grün. Neu:
  - Die HUD-Breite bleibt bei allen Werten gleich (Hitze 5/42/100 %, Rucksack 0 bis voll, Leben, Fähigkeit, Heilung, Combo).
  - Alle Symbole in Meldungen haben eine exakte Breite.
- **Live vorher/nachher:** Ein Test-Bot schlägt mit dem Schwert auf Erz, dabei kommt immer die Meldung „Dampfbohrer in die Hand nehmen“. Gezählt wurden die Aktionsleisten-Pakete:
  - **0.16.1:** 6 von 35 Paketen **ohne HUD**, bei jedem Schlag einmal. Das war das Flackern.
  - **0.16.2:** 0 von 34 ohne HUD, die Meldung steht immer über dem HUD.
- Keine Fehler im Server-Log.
