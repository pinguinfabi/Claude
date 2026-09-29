# Neu in Deepforge 0.15.3 – Menüs aufgeräumt, Fehler behoben, Prestige-Balance

Beim Serverstart steht im Log `Deepforge 0.15.3 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.15.2).

## 🪵 Holz-Menü (dein Hinweis)
- Die drei Reiter **Wald · Verarbeiten · Verbessern** stehen jetzt mittig nebeneinander. Der **offene Reiter leuchtet** und zeigt „» … «“.
- **Wald:** „Bäume fällen“, „Holzauftrag“ und „Nächster Hain“ in einer mittigen Reihe, darunter die Nachwachs-Info.
- **Verarbeiten:** Pro Holzart eine Reihe aus Holz, Sägen, Stämme verkaufen, Bretter verkaufen und Beides verkaufen. Rechts, durch eine dezente Linie getrennt, stehen „Alles verkaufen“, Holzkohle und Brennstoff. Der ganze Block steht mittig.
- **Verbessern:** alle 4 Upgrades in einer mittigen Reihe.

## 🧭 Alle Menüs geprüft
Ein Test-Bot hat **alle 35 Menüs** geöffnet. Ein Skript hat jede Reihe auf Symmetrie geprüft. Nicht mittig waren:

| Menü | jetzt |
|---|---|
| **Kampf & Ausrüstung** | 4 Knöpfe oben, 3–4 in der Mitte, Heilen unten mittig |
| **Charakter** | die 10 Ausrüstungsplätze als 2 Reihen zu 5, darunter Meisterschaft, Sets, Beutel, Meilensteine |
| **Grund-Upgrades** | Module mittig, unten Erzglück, Heiltasche, Scanner, Holz-Upgrades |
| **Lager** | Holz-Knopf nicht mehr oben rechts in der Ecke; Einlagern, Schmelzen, Erz verkaufen, Barren verkaufen, darunter Alles verkaufen und Holzlager |
| **Betrieb** | 3 Ausbauten mittig, unten 4 Knöpfe symmetrisch |
| **Mannschaft** | Arbeiter werden je nach Anzahl mittig verteilt; Brennstoff-Knopf in der Mitte statt in der Ecke |
| **Arbeiter-Detail** | „Zur Mannschaft“ und „Entlassen“ nebeneinander in der Mitte |
| **Abenteuerbuch** | Händlerin, Set-Schmiede und Tutorial in die Mitte statt zwischen die Navigationsknöpfe |
| **Set-Schmiede** | pro Set eine mittige Reihe |
| **Tutorial** | 7 Schritte über die ganze Mitte |

Listen-Seiten wie Beutel, Beutebuch oder Aufzug füllen sich Feld für Feld und bleiben so.

## 🐞 Fehler behoben
- **Runen-Knopf unsichtbar im Menü „Kampf & Ausrüstung“:** „Bossbeute & Rezepte“ lag auf demselben Feld und hat ihn überdeckt. Der Menü-Code ist jetzt automatisch auf weitere doppelt belegte Felder geprüft; es gibt keine mehr.
- **Boss-Schildphase:** Kam während der Schildphase ein Phasenwechsel, fiel der Schild weg, obwohl die Leiste noch „SCHILD“ zeigte. Jetzt bleibt er bis die Diener besiegt sind.
- **Blitzkette in der Gruppe war unausweichlich:** Ein Spieler wurde immer getroffen. Jetzt schlägt der Blitz dort ein, wo der Markierte stand (blauer Kreis). Wer rechtzeitig weggeht, weicht aus, sonst springt er auf Nahestehende über.
- Wiki-Knopf „Tiefenpass, Aufträge & Ziele“ war zu breit für den Knopf und wurde abgeschnitten, jetzt „Pass, Aufträge & Ziele“.

## ⚖ Prestige-Balance
Nach einem Prestige sind alle Gegner deutlich stärker, bisher gab es aber **nur für Erz** mehr Geld. Kämpfen hätte sich mit jedem Prestige weniger gelohnt. Jetzt gibt es **+25 % pro Prestige** auch auf:
- Geld von Minenmonstern und Champions
- Geld von Gebietsbossen
- Dungeon-Sieg, Tagesbonus und Wächtertruhen
- Tiefengang-Ebenen

„Glutader“ bleibt ein reiner Erz-Bonus. Prestige-Menü und Wiki sagen das jetzt auch so.

## Getestet
- **315 Unit-Tests** grün, neu: Kampfgeld mit Prestige.
- **Live:** Der Test-Bot öffnet alle 35 Menüs mit der neuen Version, alle Reihen sind symmetrisch. Ausnahme sind Beutebuch und Erkundung; das sind Listen, die sich der Reihe nach füllen.
- **Server-Logs** aller heutigen Testläufe: kein einziger Deepforge-Fehler.
