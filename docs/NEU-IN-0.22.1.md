# Neu in Deepforge 0.22.1 – Fehler behoben: Teleport aus der Mine zum Birkenhain

Beim Serverstart steht im Log `Deepforge 0.22.1 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.20.0). Nur `plugins/Deepforge.jar` ersetzen.

## 🐞 Fehler: In der Mine zum Waldtor teleportiert (dein Screenshot)
Wer eine Mine betrat, wurde zum Tor des Birkenhains teleportiert. Im Chat stand „Birkenhain gesperrt: erst ab Forststufe 2 …“.

- **Ursache:** Die Waldsperre aus 0.19.0 prüfte nur die Position auf der Karte (X/Z), nicht die Höhe.
  - Die Minen liegen unter dem Dorf und dem Wald.
  - Der Tiefe Schacht (Minen 8 bis 17) liegt komplett unter Birken- und Fichtenhain.
  - Darum hielt Deepforge Spieler in diesen Minen für Spieler im gesperrten Hain und setzte sie vor das Tor.
- **Behoben:**
  - Die Waldsperre greift nur noch auf Waldhöhe. Der Wald liegt bei Höhe 200, die Minen alle unter 190.
  - Tore, Meldung und Rücksetzen gibt es nur noch im Wald selbst.
  - In den Minen passiert nichts mehr.

## Getestet
- **349 Unit-Tests** grün. Neu: Für alle 17 Minen liegen Boden und Decke sicher unter der Waldhöhe.
- **Live mit Test-Bot:**
  - Vorher (0.22.0): Bot reist in Mine 8 und landet sofort vor dem Birkenhain-Tor, mit der Meldung aus deinem Screenshot.
  - Nachher (0.22.1): Bot bleibt in Mine 8 und läuft dort herum. Keine Meldung, kein Teleport, keine Fehler im Server-Log.
