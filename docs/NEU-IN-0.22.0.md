# Neu in Deepforge 0.22.0 – Open Beta: Balance und Aufräumen

Beim Serverstart steht im Log `Deepforge 0.22.0 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.20.0).

Spielstände bleiben erhalten. Die neuen Preise gelten ab dem nächsten Kauf, bereits gekaufte Stufen bleiben.

## ⚔ Dungeons deutlich schwerer (dein Hinweis)
**Problem:** Das Leben der Dungeon-Gegner wuchs nur linear mit der Mine, deine Ausrüstung aber stark. In Mine 8 hatte ein Dungeon-Gegner nur etwa ein Viertel des Lebens eines Minenmonsters. Darum waren Normal und Veteran viel zu leicht und Albtraum kaum schwer.

**Neu:**
- **Leben wächst mit der Mine** wie bei den Minenmonstern: halbe Minenkurve plus ein fester Sockel. Mine 1 bleibt für Einsteiger gleich.
- **Schwierigkeitsstufen liegen weiter auseinander:**

| | Leben | Schaden |
|---|---|---|
| Normal | ×1 | ×1 |
| Veteran | ×1,8 (vorher ×1,55) | ×1,5 (vorher ×1,35) |
| Albtraum | ×2,8 (vorher ×2,1) | ×2,1 (vorher ×1,7) |

- **Grundschaden der Gegner** etwas höher: Monster 3 statt 2,5, Boss 7 statt 6.

| Mine | Gegner Normal | Gegner Albtraum | Endboss Normal | Endboss Albtraum |
|---|---|---|---|---|
| 1 | 112 → 112 | 235 → 314 | 6.000 → 6.000 | 12.600 → 16.800 |
| 4 | 220 → 285 | 462 → 799 | 12.480 → 15.288 | 26.208 → 42.806 |
| 7 | 328 → 996 | 689 → 2.787 | 18.960 → 53.332 | 39.816 → 149.329 |
| **8** | **419 → 1.183** | **879 → 3.314** | **24.288 → 63.398** | **51.005 → 177.514** |
| 11 | 826 → 2.004 | 1.734 → 5.612 | 48.273 → 107.368 | 101.372 → 300.630 |
| 17 | 2.783 → 5.873 | 5.845 → 16.445 | 164.088 → 314.640 | 344.584 → 880.993 |

(Leben in Welle 1, Level 1, allein. Pro Dungeon-Level, Mitspieler und im Tiefengang kommt wie bisher etwas dazu.)

## 💰 Jeder Kostenpunkt auf den Fortschritt abgestimmt (dein Hinweis)
**Problem:** Dein Kollege brauchte nur 2 Stunden von Mine 7 zu Mine 8, und Upgrades wie der Bohrer gingen zu schnell. Ich habe alle rund 30 Stellen durchgesehen, an denen Geld ausgegeben wird.

Viele Preise waren feste Beträge (Heiltrank 250 $, 5 Staub für 750 $, Relikt 250.000 $) oder wuchsen nur langsam. In tieferen Minen kosteten sie praktisch nichts mehr.

**Neue Regel: Preise wachsen mit dem Erzpreis deiner Mine.** Das Einkommen wächst genauso, also kostet ein Kauf in jeder Mine ungefähr gleich viel Spielzeit. Mine 1 bis 3 bleiben günstig, damit der Einstieg schnell geht.

### Minen freischalten
| Mine | vorher | jetzt |
|---|---|---|
| 2 Kristallhöhle | 3.000 $ | 3.000 $ |
| 3 Pilztiefen | 12.000 $ | 12.000 $ |
| 4 Versunkene Schächte | 40.000 $ | 64.000 $ |
| 5 Magmaschlucht | 110.000 $ | 176.000 $ |
| 6 Vergessene Ruinen | 300.000 $ | 480.000 $ |
| 7 Leerenbruch | 800.000 $ | 2 Mio. $ |
| **8 Kernschmelze** | **2,4 Mio. $** | **6 Mio. $** |
| 9 Spiegelgrotten | 5,4 Mio. $ | 13,5 Mio. $ |
| 10–17 | 12 Mio. – 3,6 Mrd. $ | 24 Mio. – 7,2 Mrd. $ (je ×2) |

Dazu kommen wie bisher Bosssieg und Bohrerstufe. Zusammen mit den teureren Bohrerstufen dauert der Schritt von Mine 7 zu 8 etwa 2,5- bis 3-mal so lange.

### Bohrer, Grubenklinge, Schutztraining
- **Bisher:** Die Kosten wuchsen nur quadratisch. Stufe 14 kostete 45.000 $, daneben stand eine Mine für 2,4 Mio. $.
- **Jetzt:** Ab Stufe 10 kostet jede Stufe mindestens ×1,6 der vorigen. Die ersten Stufen bleiben gleich.

| Bohrer-Stufe | vorher | jetzt |
|---|---|---|
| 5 | 5.000 $ | 5.000 $ |
| 11 | 24.200 $ | 43.980 $ |
| 13 | 33.800 $ | 112.590 $ |
| **15** | **45.000 $** | **288.230 $** |
| 17 | 57.800 $ | 737.870 $ |
| 21 | 220.500 $ | 4,8 Mio. $ |
| 25+ | wie bisher (dort war die alte Kurve schon steil) | |

Klinge und Schutz folgen derselben Kurve, nur mit etwas höherem Grundpreis.

### Grund-Upgrades, Arbeiter, Forschung
| Kostenpunkt | vorher (höchste Stufe) | jetzt |
|---|---|---|
| Erzglück Stufe 10 | 50.000 $ | 1,9 Mio. $ |
| Rucksack Stufe 20 | 200.000 $ | 1,16 Mio. $ |
| Lager Stufe 8 | 76.800 $ | 1,3 Mio. $ |
| Schmelze Stufe 5 | 37.500 $ | 190.000 $ |
| Unterkunft (Arbeiterplätze) Stufe 5 | 75.000 $ | 1,2 Mio. $ |
| Arbeiter einstellen 1. bis 6. | 1.500 bis 9.000 $ | 1.500 · 6.000 · 18.000 · 48.000 · 120.000 · 288.000 $ |
| Arbeiter ausbilden | 1.000 $ × Stufe² | dazu × Preisfaktor der Mine, in der der Arbeiter arbeitet |
| Forschung Stufe 5 | 37.500 $ | 600.000 $ |

Die ersten Stufen kosten überall gleich viel wie bisher.

### Preise, die mit deiner Mine wachsen
| Kostenpunkt | Mine 1 | Mine 4 | Mine 7 | Mine 8 | Mine 12 | Mine 17 |
|---|---|---|---|---|---|---|
| Heiltrank (vorher immer 250 $) | 250 | 250 | 1.250 | 2.125 | 17.708 | 251.667 |
| 5 Schmiedestaub (vorher immer 750 $) | 750 | 1.250 | 7.500 | 12.750 | 106.250 | 1,5 Mio. |
| Relikt schmieden (vorher immer 250.000 $) | 250.000 | 250.000 | 250.000 | 408.000 | 3,4 Mio. | 48 Mio. |
| Trank brauen (einfach) | 300 | 1.200 | 3.000 | 5.100 | 42.500 | 604.000 |
| Gegenstand +1 → +2 | 500 | 4.167 | 25.000 | 42.500 | 354.167 | 5 Mio. |
| Kritwert neu würfeln (1. Versuch) | 500 | 4.167 | 25.000 | 42.500 | 354.167 | 5 Mio. |
| Runensockel bohren (1.) | 1.500 | 12.500 | 75.000 | 127.500 | 1,06 Mio. | 15,1 Mio. |
| Legendär herstellen (Beutebuch) | 3.000 | 25.000 | 150.000 | 255.000 | 2,1 Mio. | 30,2 Mio. |
| Drohne Stufe 5 → 6 | 32.832 | 68.399 | 410.395 | 697.671 | 5,8 Mio. | 82,6 Mio. |
| Begleiter füttern (episch, Stufe 5) | 50.000 | 104.167 | 625.000 | 1,06 Mio. | 8,9 Mio. | 126 Mio. |

Ebenfalls mitwachsend:
- **Talente zurücksetzen:** 1.000 $ pro Punkt × Preisfaktor ab Mine 4
- **Set-Schmiede**

Gegenstands-Preise (Verbessern, Würfeln, Sockel, Herstellen) richten sich nach der Mine des **Gegenstands**, alle anderen nach **deiner** tiefsten Mine.

**Unverändert, weil sie schon passen:**
- Lootkisten (wachsen schon mit der Dungeon-Belohnung)
- Waldupgrades (bezahlt aus dem Holzverkauf)
- Gilde gründen
- Brennstoff und Betriebsbudget

**Im Wiki:** Die Seite „Upgrades & Kosten“ zeigt jetzt echte Beispielpreise (Stufe 5, 10, 15 …) statt Formeln. So stimmt sie automatisch, wenn sich etwas ändert.

## 🧹 Aufräumen für die Open Beta
- **Anleitungen neu geschrieben:**
  - `INSTALLATION.txt` und `START-HIER.html` im Axxin-Look
  - Update-Weg, drei Wege für das Ressourcenpaket (inklusive eingebautem Download), Proxy
  - richtige Rangnamen
  - Den entfernten `/df leave` gibt es in der Anleitung nicht mehr.
- **Neu:** `docs/OPEN-BETA.md`, alle Spielsysteme, Spielerbefehle und Admin-Befehle auf einen Blick.
- **Docs-Ordner aufgeräumt:**
  - 65 alte Versionshinweise und Konzepte liegen in `docs/archiv/`.
  - Im Hauptordner bleiben die Hinweise ab 0.16.0, `PROXY.md` und `TAB-UND-AUTOLOGIN.md`.
- **Prüfsummen:** `SHA256SUMS.txt` ist komplett neu erzeugt. Vorher stimmten 8 Einträge nicht und die Bilder fehlten.
- **Code:**
  - Veraltete Paper-Schnittstellen ersetzt. Totem-Effekt, Chorusfrucht-Teleport und Klick-Abfrage wären mit einem späteren Paper-Update kaputtgegangen.
  - Compiler-Warnungen behoben.
- **Lernziel-Leiste:** Die gelbe „Lernziel“-Leiste verschwindet während Bosskämpfen und Dungeons und überdeckt die Bossleiste nicht mehr.
- **Admin-Hilfe:** `/df admin hilfe` (oder ein unbekannter Unterbefehl) listet jetzt auch die Testbefehle für Monster, Bosskampf, Bossphase, Unverwundbarkeit und Weltereignisse.
- **Menüs:** Drohnen- und Arbeiterpreise mit Tausenderpunkt.

## Getestet
- **348 Unit-Tests** grün. Neu sind 4 Balance-Tests:
  - Dungeon-Leben folgt der Minenkurve: mindestens die Hälfte, nie mehr als die Mine.
  - Veteran- und Albtraum-Abstände stimmen.
  - Minenpreise steigen in der richtigen Reihenfolge.
  - Klinge und Schutz folgen der steileren Kurve, die ersten Stufen bleiben gleich.

  Außerdem prüft ein Test für alle Minen, dass die zwei Bohrerstufen einer Mine ein echter Teil ihres Preises sind.
- **Live auf dem Testserver mit Bot:**
  - Alle 28 `/df`-Befehle und 44 Menüseiten automatisch durchgeklickt, keine Fehler im Server-Log.
  - In Mine 8 zeigen die Menüs die neuen Preise (z. B. Relikt 408.000 $, Drohne 308.104 $, Tränke 5.100 bis 15.300 $).
- **Serverstart:** keine Deepforge-Warnungen im Log.
