# Neu in Deepforge 0.22.4 – Arbeiter: sichtbarer Grund, versetzte Pausen, Löhne automatisch

Beim Serverstart steht im Log `Deepforge 0.22.4 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.20.0). Nur `plugins/Deepforge.jar` ersetzen.

## 👷 Arbeiter standen einfach herum (dein Screenshot)
Ich habe die Arbeiter auf dem Testserver nachgestellt: zwei Bergarbeiter Stufe 5 in Mine 5 mit vollem Budget. Sie liefen dauerhaft ihre Runde: zur Erzader, 12 Schläge, zurück zum Depot, nächste Ader. Einen Fehler in den Laufwegen gibt es also nicht.

Arbeiter bleiben aber stehen, wenn:
- sie Schichtpause haben (10 Minuten nach je 50 Minuten)
- das Lager voll ist
- Budget oder Brennstoff fehlen
- sie pausiert sind

Den Grund gab es bisher nur im Arbeiter-Menü. Außerdem fiel mir auf: Wer zusammen eingestellt wurde, hat **gleichzeitig Pause**. Meine zwei Test-Arbeiter hatten exakt dieselbe Schichtzeit, also stand die ganze Mannschaft auf einmal still.

### Jetzt
- **Grund über dem Kopf:** Steht ein Arbeiter still, schwebt über ihm z. B. rot **„⏸ Lager voll“** oder gelb **„☕ Macht Pause (6 Min.)“**. Sobald er weiterarbeitet, verschwindet die Anzeige.
- **Chat-Hinweis mit Lösung**, höchstens alle 5 Minuten je Grund. Beispiel: „Deine Arbeiter stehen still: Lager voll. Lösung: Erz verkaufen, Händler einstellen oder das Lager ausbauen.“ Bei normalen Pausen kommt keine Nachricht.
- **Pausen versetzt:** Arbeiter mit gleicher Schichtzeit werden einmal gleichmäßig über die Schicht verteilt, bei 6 Arbeitern etwa 8 Minuten auseinander. Das gilt beim Betreten und bei jeder Neueinstellung. Wie lange sie arbeiten, ändert sich dadurch nicht, nur wann sie Pause machen.

## 💰 Löhne automatisch zahlen (neu, Standard: AN)
- **Problem:** Der Lohn hängt am Wert der geförderten Ware, in tiefen Minen also mehrere hundert Dollar pro Minute und Arbeiter. Das Budget ließ sich aber nur mit 100 $ oder 1.000 $ aufladen und war schnell leer.
  - Das Menü zeigte dabei weiter „arbeitet“, weil es nur den Grundlohn von ein paar Dollar prüfte. Gefördert wurde trotzdem nichts.
- **Jetzt:**
  - Reicht das Budget nicht, zahlt Deepforge den fehlenden Lohn und Brennstoff (60 Einheiten für 60 $) direkt von deinem Geld. Das gilt auch offline.
  - Schalter unter **Betrieb → „Löhne automatisch zahlen: AN/AUS“**. Mit AUS stoppen die Arbeiter wie bisher bei leerem Budget.
- **Anzeige stimmt jetzt:** Die Statusanzeige zeigt, woran die letzte Arbeitsminute wirklich gescheitert ist, also z. B. „Betriebsbudget fehlt“ für den vollen Lohn statt nur für den Grundlohn.

## Getestet
- **351 Unit-Tests** grün. Neu: Eine gemeinsam eingestellte Mannschaft hat danach mindestens 5 Minuten Abstand zwischen den Pausen. Die Förderung pro Stunde bleibt gleich, die bestehenden Produktionstests sind unverändert.
- **Live mit Test-Bot:**
  - Zwei Bergarbeiter Stufe 5 in Mine 5 liefen 3 Minuten durchgehend ihre Runden.
  - Mit vollem Lager: rote Anzeige „⏸ Lager voll“ über beiden Arbeitern plus Chat-Hinweis mit Lösung.
  - Keine Fehler im Server-Log.
