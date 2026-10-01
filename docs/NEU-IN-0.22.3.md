# Neu in Deepforge 0.22.3 – Richtige Preisanzeigen, Runen getrennt, Beutel nach Slot filtern

Beim Serverstart steht im Log `Deepforge 0.22.3 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.20.0). Nur `plugins/Deepforge.jar` ersetzen.

## 🔨 „Verbessern“-Knopf zeigte falsche Werte (dein Screenshot)
- **Bei +10 (Maximum)** stand noch „Verbessern +11“ mit Preis. Jetzt steht dort „Verbessern · +10 erreicht – +11 nur mit Sternenstein“. Der Knopf ist dann nicht mehr klickbar.
- **Der Preis** wurde im Menü mit einer alten Formel berechnet und stimmte nicht mit dem echten Preis überein. Jetzt zeigt das Menü genau den Betrag, der auch abgezogen wird.

## 🔍 Alle Anzeigen geprüft
Ich habe jede Stelle durchgesehen, an der ein Preis oder eine Belohnung angezeigt wird.
- **Nur noch echte Werte:** Keine Anzeige rechnet mehr selbst. Alle holen den Wert aus derselben Funktion wie der Kauf.
- **Tausenderpunkt überall,** z. B. `13.750 $` statt `13750 $`. Das gilt für:
  - Upgrades, Forschung, Arbeiter, Drohne, Gilde, Talente
  - Heiltränke, Händlerin, Minen-Freischaltung, Aufträge
  - Dungeon-Belohnung, Set-Schmiede, Sockel, Begleiter
- **Fundkisten in den Minen** zahlen jetzt passend zur Mine. Vorher waren es nur 250 $ × Mine, in Mine 17 also 4.250 $, was dort nichts wert war. Mine 1 bleibt bei 500 $.

## 💎 Runen getrennt anzeigen (dein Wunsch)
- **Gegenstand:** Die Werte zeigen den Gegenstand selbst, die Runen stehen in Klammern dahinter. Beispiel: `Schaden 3,3 (+2 Runen)`. Vorher war die Rune schon im Wert eingerechnet.
- **Vergleich „Gegenüber ausgerüstet“:** Der Unterschied der Gegenstände und der Unterschied durch Runen stehen getrennt. Beispiel: `▲ Schaden −1,1 (+2 Runen)` heißt: Der Gegenstand selbst ist 1,1 schwächer, aber seine Runen bringen 2 mehr.
  - So erkennst du ein besseres Teil, auch wenn darauf noch keine Runen sitzen. Die Runen kann man umsetzen.
- Der Pfeil ▲/▼ zeigt weiter das Gesamtergebnis.

## 🗡 Klick auf einen Slot zeigt nur passende Teile (dein Wunsch)
- **Charakter-Menü:** Ein Klick auf einen Ausrüstungsplatz öffnet den Beutel **nur mit Teilen dieses Platzes**, z. B. nur Waffen oder nur Stiefel. Das gilt auch, wenn dort schon etwas angelegt ist.
- **Beutel:** neuer Knopf **„Filter“** oben rechts (Trichter):
  - schaltet durch Alle → Waffe → Nebenhand → … → Bergbaumodul
  - zeigt zu jedem Platz die Anzahl
- **„Filter aufheben“** oben links bringt wieder alles.
- Blättern, „Ganze Seite auswählen“, Verkaufen und Zerlegen beachten den Filter.

## Getestet
- **350 Unit-Tests** grün. Neu: Vergleich mit Runen, Gegenstand selbst und Runen getrennt.
- **Live mit Test-Bot:**
  - Charakter → Waffen-Platz: Beutel zeigt „BEUTE · 4 × Waffe“, nur Waffen.
  - Waffe mit Kraftrune: `Schaden 3,3 (+2 Runen)` und im Vergleich `▲ Schaden −1,1 (+2 Runen)`.
  - Testdolch +10: „Verbessern · +10 erreicht“, nicht klickbar. Andere Waffen zeigen den richtigen Preis (+2 → +3: 750 $).
  - Filter-Knopf: Liste mit Anzahl je Platz, Klick schaltet auf „Waffe“.
  - Keine Fehler im Server-Log.
