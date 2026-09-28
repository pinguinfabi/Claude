# Neu in Deepforge 0.5.2

Beim Serverstart steht im Log `Deepforge 0.5.2 ready`.
**Neues Ressourcenpaket** (SHA-1 `3c5e6214f9f1668ec2d1063c36753b799524fe2a`) – enthält den neuen Pfeil nach rechts.

## Dungeon-Menü neu und übersichtlich
Das Menü (`/df dungeon`) ist jetzt in vier Schritte von oben nach unten aufgeteilt:

| Zeile | Inhalt |
|---|---|
| oben | **Zusammenfassung** der aktuellen Wahl: Dungeon, Gebiet, Endboss, Gefahr, Beute, dein Level |
| ① Dungeon wählen | Runengewölbe · Glutschmiede · Frostkrypta – die Auswahl leuchtet, gesperrte zeigen ein Sperrschild und den Grund |
| ② Gebiet wählen | ◀ Pfeil · aktuelles Gebiet (mit deinem Level dort) · Pfeil ▶ |
| ③ Schwierigkeit & Start | Normal · Veteran · Albtraum – mit Geld, Boss-LP und Beutechancen. Unten steht immer, **warum** es (noch) nicht geht: „✖ fehlt bei: Tom (Normal-Sieg fehlt)“, „✖ Noch nicht alle bereit (1/2)“, „✖ Nur der Partyleiter kann starten“ oder „✔ Klick: jetzt starten!“ (leuchtet) |
| ④ Party | alle Mitglieder mit ✔/✖ bereit · „Bereit melden“ · Party verlassen · Zuschauen |
| unten | Zurück · Hauptmenü · Schließen · „So läuft ein Dungeon“ · Heilen |

- Der **Pfeil nach rechts** zeigt jetzt wirklich nach rechts (vorher war es der Zurück-Pfeil). Auch „Nächste Seite“
  im Beutebeutel nutzt ihn.
- Ohne Ressourcenpaket siehst du passende normale Items (Steinziegel, Magmablock, Packeis, Schwerter, Barriere).

## Eigenes Dungeonlevel pro Gebiet
- Jedes Gebiet hat jetzt **sein eigenes Dungeonlevel**. Ein Sieg erhöht nur das Level in diesem Gebiet
  (egal welcher Dungeon oder welche Schwierigkeit).
- Neue Gebiete starten bei Level 1. Du musst also nicht mehr mit einem hohen Level aus Gebiet 1 in Gebiet 2 anfangen.
- Bestehende Spielstände: Jedes Gebiet startet bei **1 + deine bisherigen Siege in diesem Gebiet**.
- In der Party gilt das höchste Level der Mitglieder **in diesem Gebiet**.
- Anzeige:
  - Menü: Zusammenfassung und Gebietsfeld
  - Scoreboard/Tab: „Gewölbe ▸ Level X · Gebiet Y“ für dein höchstes Gebiet
  - Charakter: alle Gebiete
  - Beute-Fenster nach dem Sieg: „Dungeonlevel Gebiet 2: 3 → 4“
