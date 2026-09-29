# Neu in Deepforge 0.11.0 – Dungeon-Überarbeitung: Wächter, neue Bossangriffe, echte Schwierigkeit

Beim Serverstart steht im Log `Deepforge 0.11.0 ready`.

Zum Ressourcenpaket:
- Es gibt ein **neues Ressourcenpaket** mit 7 neuen Icons: sechs Wächter und die Wächtertruhe.
- Die SHA-1 steht in `resourcepack/pack.sha1` und ist in `config.yml` schon eingetragen.

Ziel dieses Updates: Veteran und vor allem Albtraum sollen **wirklich schwer** sein. Nicht nur mehr Leben, sondern neue Mechaniken, die man lernen muss.

## ⚔ Neu: Wächter (Minibosse)
Wächter bewachen einzelne Räume. Sie erscheinen mit der **letzten Welle** ihres Raums. Diese Welle hat dafür nur halb so viele normale Gegner.

| Schwierigkeit | bewachte Räume |
|---|---|
| Normal | 1 |
| Veteran / Albtraum | 2 (nie zweimal derselbe Wächter) |

Jeder Wächter hat eine **Regel**, reiner Schaden reicht nicht:

| Wächter | Regel |
|---|---|
| 🛡 **Schildträger** | Vorne blockt der Schild alles. Treffer zählen nur **von hinten**. Nach jedem Sturmangriff senkt er kurz den Schild, dann trifft man von überall („SCHILD GESENKT“). |
| 💀 **Beschwörer** | Ruft immer wieder Diener (2 + Schwierigkeit, in großen Gruppen mehr). **Immun, solange ein Diener lebt** (blauer Ring). |
| 👥 **Zwillinge** | Zwei Wächter. Fällt einer, muss der zweite in **5 Sekunden** folgen, sonst steht der erste mit halbem Leben wieder auf. Countdown in der Aktionsleiste. |
| 🪞 **Spiegelritter** | Leuchtet regelmäßig weiß. Wer dann zuschlägt, **bekommt den Schaden selbst**. Auf Albtraum leuchtet er öfter und länger. |
| ⛓ **Kettenbrecher** | Jeder Spieler hängt an einer Kette. Wer **mehr als 7 Blöcke** entfernt ist, nimmt jede Sekunde Schaden und wird zurückgezogen. |
| 🌿 **Wurzelhexe** | Lässt Dornen aus dem ganzen Boden brechen. Sicher ist nur, wer auf einer der **grünen Inseln** steht. Auf Albtraum gibt es weniger Inseln (ihr müsst teilen) und weniger Vorwarnzeit. |

- **Stärke:** Wächter haben 35 % des Bosslebens (Zwillinge je 22 %) und treffen 60 % härter als normale Gegner.
- **Ansage:** Auf Normal und Veteran wird die Regel per Titel angesagt. **Auf Albtraum nicht:** „Finde seine Schwäche selbst heraus!“
- **Wächtertruhe** für jeden Spieler:
  - ¼ des Dungeon-Geldes
  - Schmiedestaub (10 + 5 × Schwierigkeit + Gebiet)
  - ein Ausrüstungsteil, mindestens **selten**, mit den Dungeon-Chancen des Levels
  - Tiefenpass-XP

## 👹 Endboss: neue Angriffe und echte Schwierigkeitsstufen
### 5 neue Angriffe
| Angriff | Was tun |
|---|---|
| **Meteoritenhagel** | Drei Einschlag-Salven, die dir folgen. In Bewegung bleiben! |
| **Erdspalten** | Drei Risse quer durch die Arena. Sie **bleiben 10 s offen** und brennen, also nicht darauf stehen. |
| **Blitzkette** | Trifft einen Spieler und springt auf alle in 5 Blöcken Nähe über. Verteilt euch! |
| **Todesmarke** | Ein Spieler wird markiert (violetter Kreis). Nach 2,5–4 s explodiert die Marke. Sie trifft alle in 5 Blöcken um ihn, und ihn selbst, wenn er näher als 6 Blöcke am Boss steht. Der Markierte muss weg von allen **und** vom Boss. |
| **Schildphase** | Der Boss wird unverwundbar und ruft Diener. Erst wenn alle tot sind (oder nach 20 s), bricht der Schild. |

### Welche Angriffe auf welcher Stufe
| | Phase 1 | Phase 2 | Phase 3 |
|---|---|---|---|
| **Normal** | wie bisher | wie bisher | + Meteoritenhagel |
| **Veteran** | wie bisher | + Erdspalten | + Meteoritenhagel, Blitzkette |
| **Albtraum** | + Meteoritenhagel | + Erdspalten, Todesmarke | + Blitzkette, Schildphase |

### Was die Schwierigkeit jetzt zusätzlich macht
| | Normal | Veteran | Albtraum |
|---|---|---|---|
| Bossschaden (zusätzlich) | ×1 | ×1,2 | ×1,6 |
| Warnzeit vor Angriffen | 100 % | 78 % | 58 % |
| **Kombos** (Angriff folgt sofort auf Angriff) | – | 35 %, bis 2 | 60 %, bis 3 |
| Wut nach | 6 Min. | 5 Min. | 4 Min., dann **+20 % Schaden alle 30 s** |
| Brennender Arenarand in Phase 3 | – | zieht sich bis 9 Blöcke zusammen | zieht sich bis 7 Blöcke zusammen |
| Heilung in Phase 3 | ja | ja | **gesperrt** („Der Boss blockiert jede Heilung“) |

## 🧩 Rätsel: deutlich schwerer
| | Normal | Veteran | Albtraum |
|---|---|---|---|
| Zeitlimit | keins | 2 Minuten | 75 Sekunden |
| Runenwand / Glocken | 5 Zeichen | 7 Zeichen | 9 Zeichen, keine direkten Wiederholungen |
| Druckplatten | wie bisher | längere Folge, kürzeres Fenster | noch länger, noch kürzer |
| Spiegel | wie bisher | mehr Drehungen, mehr Attrappen | noch mehr Attrappen |
| Fehler | wie bisher | kostet Leben und ruft Gegner | kostet Leben und ruft Gegner |
| Erklärung an der Wand | ja | ja | **nein**, auch kein Hinweis |

## 📊 Siegeshalle: wer wurde wovon getroffen?
- Die Abschluss-Statistik zeigt jetzt für jeden Spieler **„getroffen von: Meteoritenhagel 3× · Blitzkette 1× …“**. Auch Wächter-Mechaniken wie Spiegelung, Kette und Dornen zählen dazu.
- Darunter steht der **gefährlichste Angriff** des Laufs.
- Ausgewichene Treffer (Rolle, Parade, Sternenschild) zählen **nicht**.

## 📖 Wiki
Unter **Dungeons** gibt es zwei neue Seiten:
- **Wächter (Minibosse):** alle 6 mit Icon, Regel und Belohnung.
- **Endboss & Schwierigkeit:** alle 13 Bossangriffe mit Warnung und die ganze Stufen-Tabelle.

Außerdem:
- Die Dungeon-Seite erklärt jetzt die Rätsel-Regeln auf Veteran und Albtraum.
- Die Geld-Formel auf der Dungeon-Seite ist aktualisiert (etwa 90 Erze des Gebiets pro Sieg).

## 🔧 Admin-Testbefehle
| Befehl | Wirkung |
|---|---|
| `/df admin guard <shield\|caller\|twins\|mirror\|chain\|root>` | Wächter im aktuellen Raum erscheinen lassen (während einer Welle) |
| `/df admin phase <1–3>` | Endboss in eine Phase springen lassen |
| `/df admin gott` | Unverwundbar an/aus (zum Testen der Mechaniken) |

## Getestet
- **287 Unit-Tests** grün, 9 neue:
  - Angriffe je Stufe und Phase
  - Warnzeiten, Wut und Arenarand
  - Blitzketten-Reichweite und Erdspalten-Geometrie
  - Wächter-Räume (nie Raum 1, nie Bossraum, deterministisch)
  - alle Wächter-Regeln
  - Wächtertruhe
  - Treffer-Statistik
  - Wiki-Seiten
- **Live mit Bot auf Albtraum:**
  - Alle 6 Wächter wurden gespawnt, angegriffen und angesagt.
  - Der Beschwörer ruft Diener.
  - Der Boss nutzt in Phase 1 schon Kombos (Runenstrahl → Meteoritenhagel).
  - In Phase 3 kamen Schildphase mit Dienern, Schildbruch, der brennende Rand und die Ansage „Keine Heilung mehr“.
  - Die Siegeshalle zeigt „getroffen von“ und „Gefährlichster Angriff: Spiegelung (Spiegelritter)“.
  - Keine Fehler im Server-Log.
