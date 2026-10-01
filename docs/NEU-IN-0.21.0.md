# Neu in Deepforge 0.21.0 – Neue Monster und spannendere Gebietsbosse

Beim Serverstart steht im Log `Deepforge 0.21.0 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.20.0).

## 👾 Zwei neue Monsterarten (dein Wunsch „mehr Auswahl“)
Bisher gab es in Minen und Wald nur 3 Arten. Jetzt sind es 5, und die neuen verlangen Ausweichen statt nur Draufhauen.

| Mine | Wald | Ab | Verhalten |
|---|---|---|---|
| **Sprengling** | **Sporenbovist** | Mine 2 / Birkenhain | Rennt heran, glüht 1,5 s rot (blinkender Kreis, Zündgeräusch) und **platzt**. Schnell aus dem Kreis laufen oder ihn vorher erledigen. Wenig Leben (×0,6). Wer platzt, lässt keine Beute fallen. |
| **Felsspringer** | **Rankenluchs** | Mine 3 / Birkenhain | Hält Abstand, **markiert** den Boden unter dir (oranger Kreis) und **springt** nach 1,3 s genau dorthin. Weglaufen! Etwas zäher (×1,2). |

- **Eigene Körperform**, damit man sie sofort erkennt:
  - Sprengling: klein, breit und gedrungen, mit kurzen Armen
  - Felsspringer: groß und schlank, mit langen Armen
- **Gleiche Optik wie die Mine** und gleiche Schlag-Animationen. Wie alle Monster können sie Champions werden.
- **Der Dungeon-Rissjäger** hat jetzt die schlanke Jäger-Form.
- **Klassiker bleiben häufiger:** Krabbler, Panzerwächter und Werfer kommen weiter am meisten. Mine 1 bleibt beim Einstieg mit den 3 alten Arten.
- **Schaden:** Explosion = 2 Berührungstreffer, Sprung = 1,7 Berührungstreffer. Beides liegt etwa auf Höhe des Werfer-Strahls.
- **Beute:**
  - Sprengling: 1 Monsterteil
  - Felsspringer: 2 Monsterteile
  - Im Wald gibt es Holz wie bisher.

## 👑 Gebietsbosse: mehr Angriffe, echte Phasen
Bisher kannte jeder der 17 Gebietsbosse **3 Angriffe in fester Reihenfolge**. Jetzt gilt:

- **Neue Angriffe in jeder Phase:**
  - **Phase 1:** 2 Angriffe
  - **Phase 2:** 4 Angriffe
  - **Phase 3:** 5 Angriffe
- **Zufällige Reihenfolge** in jeder Runde, nie zweimal derselbe Angriff hintereinander. Auswendig lernen geht nicht mehr.
- **4 neue Angriffe.** Jeder Boss hat 2 davon als Signatur:
  - **Sturmangriff:** Der Boss rennt eine rot markierte Bahn entlang und bleibt am Ende stehen. Raus aus der Bahn!
  - **Kreuzstrahl:** 4 Strahlen in Kreuzform. Sicher ist man nur in den Ecken dazwischen.
  - **Nova:** Ein grüner Kreis direkt am Boss, alles außerhalb explodiert. **Ganz nah ran!** (Das Gegenteil von dem, was man sonst tut.)
  - **Felsregen:** Felsbrocken fallen auf jeden Spieler und verstreut in der Arena. Kreise und rieselnder Staub zeigen, wo. In Bewegung bleiben.
- **Phasenwechsel** bei 70 % und 35 % Leben:
  - Der Boss brüllt.
  - Er ist **2 Sekunden unverwundbar**. Die Bossleiste zeigt „UNVERWUNDBAR“, Treffer prallen mit Schildklang ab.
  - Er stößt alle in der Nähe zurück.
  - Er ruft **Verstärkung**, auch die neuen Monsterarten.
  - Im Chat: „⚠ SPORENHÜTER · PHASE 2 – er wird wütend und lernt neue Angriffe!“
- **Schwierigkeit:** Veteran bringt den Felsregen in Phase 3 dazu, Albtraum schon in Phase 2.
- **Wiki:**
  - Jede Minenseite zeigt die Monsterarten der Mine und welche Bossangriffe in welcher Phase dazukommen.
  - „Bosse & Champions“ erklärt alle 5 Monsterarten mit Tipp.

## 🛠 Fehler nebenbei behoben
- **Waldchampions** hießen im Chat „Erzkrabbler“ oder „Panzerwächter“ statt „Moosling“ oder „Borkenwächter“.

## Getestet
- **344 Unit-Tests** grün. Neu sind 7 Tests:
  - Mine 1 hat nur die 3 Klassiker, neue Arten kommen ab Mine 2/3, die Klassiker bleiben häufiger.
  - Explosions- und Sprungkreise haben klare Ränder.
  - Aus dem Sprengling-Kreis kann man rechtzeitig herauslaufen.
  - Bei allen 17 Bossen wächst das Angriffsset mit jeder Phase.
  - Die Reihenfolge wiederholt nie denselben Angriff direkt hintereinander, auf allen Schwierigkeiten.
  - Geometrie der 4 neuen Angriffe stimmt.
- **Live mit Test-Bot (Pilztiefen):**
  - Sprengling erschaffen: glüht, platzt, trifft.
  - Felsspringer erschaffen: markiert, springt, trifft.
  - Bosskampf Sporenhüter:
    - Phase 1: Sporenfeld, Armschlag
    - Phase 2: Brüllen, „UNVERWUNDBAR“, dann zusätzlich Einschlag und Nova
    - Phase 3: zusätzlich Sturmangriff
    - Reihenfolge wechselt, keine Fehler im Server-Log.
