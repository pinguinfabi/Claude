# Neu in Deepforge 0.7.0 – das große Update

Beim Serverstart steht im Log `Deepforge 0.7.0 ready`.
**Neues Ressourcenpaket** (SHA-1 `27421da96dfae38216b9d6032fd8afd0262cd0ef`). Wer ein eigenes `resource-pack.url` nutzt: neue ZIP hochladen und den SHA-1 in der `config.yml` eintragen. Mit Self-Host oder leerem `sha1` passiert das automatisch.

## Tiefenpass – 30 Belohnungsstufen pro Saison
- Eine **Saison dauert 28 Tage**, danach beginnt eine neue für alle.
- **XP gibt es für alles, was man sowieso macht:**

  | Tätigkeit | XP |
  |---|---|
  | Erz | 1 |
  | Monster | 4 |
  | Baum | 8 |
  | Rätsel | 25 |
  | Auftrag | 40 |
  | Boss | 60 |
  | Tagesaufgabe | 80 |
  | Dungeon-Sieg | 200 |

- **Belohnungen:** Geld (wächst mit deinem Gebiet), Schmiedestaub, Lebenssplitter, Relikte, Forschungsnotizen und auf **Stufe 10 / 20 / 30 seltene, epische und legendäre Ausrüstung**.
- Nach Stufe 30 gibt es alle 1.500 XP eine **Bonusstufe** (Staub und Lebenssplitter).
- Beim Stufenaufstieg erscheint ein Titel und ein anklickbarer Knopf **[Belohnung abholen]** im Chat.
- Menü: `/df pass` oder Hauptmenü → Stern (unten rechts). Mit **„Alle abholen“** holst du alles auf einmal.
- Die Seitenleiste zeigt die aktuelle Tiefenpass-Stufe (✔ = etwas abholbar).

## Weltereignisse – für alle gleichzeitig
Etwa alle 45 Minuten startet für 10 Minuten ein zufälliges Ereignis für den ganzen Server, mit Titel, Horn und Bossleiste samt Countdown:

| Ereignis | Wirkung |
|---|---|
| **Goldrausch** | Erz und Barren verkaufen sich für +50 % |
| **Erzrausch** | 50 % Chance auf ein Extra-Erz pro Block |
| **Monsterflut** | Minenmonster: doppelte Beute- und Lebenssplitter-Chance |
| **Tiefenfieber** | Doppelte Tiefenpass-XP |

- `/df event` zeigt, was gerade läuft bzw. wann das nächste Ereignis kommt. Es steht auch im Hauptmenü oben rechts.
- **Einstellbar** in der `config.yml` unter `events:`:
  - `world-events` (an/aus)
  - `world-interval-minutes`
  - `world-duration-minutes`
  - `world-min-players`
- **Admin:** `/df admin event goldrausch|erzrausch|monsterflut|tiefenfieber [Minuten]` startet ein Ereignis sofort, `/df admin event stop` beendet es.

## Ausrüstungs-Sets (Presets)
- **4 Sets** speichern, zum Beispiel „Dungeon“, „Mining“, „Boss“ und ein freies. Mit einem Klick legst du die komplette Ausrüstung um.
- Menü: Charakter → **Ausrüstungs-Sets**. Jedes Set hat drei Knöpfe:
  - **anlegen**
  - **aktuelle Ausrüstung speichern**
  - **Automatik**
- **Automatik:** ein Set wird **beim Dungeon-Start** oder **nach dem Dungeon** von selbst angelegt, zum Beispiel das Dungeon-Set rein und das Mining-Set danach wieder.
- **Befehle:**
  - `/df sets` öffnet die Übersicht.
  - `/df sets 2` oder `/df sets Mining` legt ein Set an.
  - `/df sets speichern 2` speichert die aktuelle Ausrüstung.
  - `/df sets name 2 Bossjagd` benennt ein Set um.
- Teile, die in einem Set stecken, sind **vor Verkaufen und Zerlegen geschützt**. Auch die Set-Schmiede nimmt sie nicht.

## Bohrer- und Schwert-Upgrades spürbar stärker
- **Bohrer:** jede Stufe **+12 % Abbautempo** auf die vorige, und der Bohrer wird **weniger heiß**.

  | Bohrer-Stufe (Eisenmine) | vorher | jetzt |
  |---|---|---|
  | 0 | 2,2 s pro Erz | 2,2 s pro Erz |
  | 5 | 1,4 s pro Erz | **1,25 s** pro Erz |
  | 10 | 1,0 s pro Erz | **0,75 s** pro Erz |

  In jedem neuen Gebiet fühlt sich der Bohrer auf der Pflichtstufe gleich an und wird mit jedem Upgrade klar schneller.
- **Grubenklinge (Schwert):** jede Stufe gibt jetzt **+6 % auf deinen gesamten Nahkampfschaden**, auch mit Beute-Waffen. Vorher waren es nur +0,7 Grundschaden. Stufe 5 = +30 %, Stufe 10 = +60 %.
- Das Upgrade-Menü zeigt jetzt die **echten Werte vorher → nachher**, zum Beispiel „Eisenmine: 1,25 s → 1,15 s pro Erz“ bzw. „Trefferschaden 18,4 → 19,9“.

## Leben immer sichtbar, Herzen und Hunger ausgeblendet
- Die normale **Herzleiste und die Hungerleiste sind weg** (über das Ressourcenpaket).
- Das **Leben steht immer in der HUD-Leiste**: beim Abbauen, im Kampf und auch dann, wenn gerade ein Hinweis angezeigt wird.
- Ohne Ressourcenpaket bleibt alles wie in Vanilla.

## Fehlerbehebung: Segen im Dungeon
- In den neuen, generierten Dungeons konnte man ab dem dritten Raum keinen Segen mehr wählen („bereits gewählt“). Außerdem landeten Schreine manchmal in der Wand oder über dem Abgrund.
- Jetzt gibt es **nach jedem Kampfraum einen Segen**:
  - am Schrein per Rechtsklick
  - **oder per Klick im Chat**: `[KRAFT] [SCHUTZ] [QUELLE]`, auch als `/df dungeon segen 1|2|3`
- Die Schreine stehen immer frei an einer Wand ohne Tür.
- Gleiche Segen stapeln sich bis zu 3× (max. +24 % Schaden bzw. −24 % erlittener Schaden).

## Aus 0.6.1 (falls noch nicht eingespielt)
- **Kombo im Dungeon**
- **Tränke-Schnellkauf:**
  - Rechtsklick bzw. Shift-Klick auf „Heilen“
  - `/df heal kaufen [Anzahl|voll]`
  - bei der Händlerin 1 / 5 / Auffüllen
