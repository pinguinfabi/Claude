# Neu in Deepforge 0.6.0

Beim Serverstart steht im Log `Deepforge 0.6.0 ready`. Ressourcenpaket unverändert (wie 0.5.2).

## Dungeons werden jetzt generiert – jeder Lauf ist anders
Statt drei fester Hallen in einer Linie baut jeder Lauf einen **eigenen Grundriss**:

- **5 bis 8 Räume**, verbunden durch **verwinkelte Gänge** mit Kurven, Umwegen und **Treppen**
  (Räume liegen auf unterschiedlichen Höhen). Der Weg führt mal geradeaus, mal zur Seite.
- **Raumarten:** Halle, Säulenhalle, Gruft (niedrige Decke, Sarkophage), Kammer, **Brücke über einem
  Abgrund** (wer runterfällt, landet am Eingang und verliert etwas Leben), **Fallengang** und am Ende immer die
  **runde Boss-Arena**. Alles im Stil des gewählten Dungeons (Runengewölbe, Glutschmiede, Frostkrypta).
- **1–2 Nebenräume** zweigen ab und öffnen sich, wenn ihr den Raum davor geschafft habt:
  - **Prüfungskammer**: Elite- oder Fluchprüfung (wie bisher, Gruppenleiter startet)
  - **Zellentrakt**: gefangenen Bergarbeiter befreien (Bonusfund + Händlerrabatt)
  - **Schatzkammer**: braucht den **Schlüssel aus einem verstaubten Fass** in einem der Räume davor
- Die Wellen verteilen sich auf die Räume, der Endboss wartet im letzten Raum.
- **Mehr Zeit:** 20 Minuten + 6 pro Raum (also 50–68 Minuten statt 30).
- Die Bossleiste zeigt Raumname, „Raum 3/7“, was gerade zu tun ist und die Restzeit.
- Alle Gegner bleiben in ihrem Raum (nicht nur der Boss).
- Das Bauen dauert nur ein paar Sekunden.

## 8 Rätsel – 2 bis 3 pro Lauf, zufällig
| Rätsel | So geht's |
|---|---|
| **Runenfolge** | Farbfolge in der Bossleiste merken, dann die Runen an der Wand in der Reihenfolge anklicken |
| **Gruppensiegel** | Die türkisen Platten gleichzeitig 3 Sekunden besetzen (solo 1, zu zweit 2, ab drei alle 3) |
| **Hebelrätsel** | Jeder Hebel schaltet seine Lampe **und die beiden daneben** um – alle 5 Lampen müssen leuchten |
| **Plattenlauf** | Immer auf die leuchtende Platte laufen, bevor die Zeit abläuft (5–8 Platten, später schneller) |
| **Lichtstrahl** | Spiegel drehen (Sockel anklicken), bis der Lichtstrahl den Kristall trifft |
| **Fallengang** | Glutdüsen feuern im Takt quer durch den Gang – in den Lücken bis ans andere Ende |
| **Glockenmelodie** | Die Melodie anhören und auf den 4 Glocken nachspielen (`/df dungeon hint` spielt sie nochmal) |
| **Falsche Truhen** | 5 Truhen, nur eine hat den Schlüssel – die anderen sind **Mimics** und greifen an |

Fehler kosten ein wenig Leben, das Rätsel startet dann neu. Jedes Rätsel hat im Raum eine Beschriftung.

## Kleinigkeiten
- **Solo nochmal starten:** Nach einem Lauf musste man als Einzelspieler erst „Bereit“ drücken – jetzt reicht
  der Klick auf die Schwierigkeit.
- **Mine 4 / Mine 3:** Der Dauerschaden (Grubenwasser bzw. Sporenluft ohne genug Schutztraining) wird jetzt im
  Chat erklärt, und der Aufzug zeigt die Gefahr und ob du geschützt bist (Mine 3: Schutztraining 2, Mine 4: 4).
- **Holzlager:** zeigt jetzt Stämme **und** Bretter je Holzart (im Holzfäller-Menü oben und im Lager `/df lager`).
- Admin-Testbefehle: `/df admin skip` (Raum überspringen), `/df admin plan` (Grundriss anzeigen).
