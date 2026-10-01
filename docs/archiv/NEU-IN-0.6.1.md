# Neu in Deepforge 0.6.1

Beim Serverstart steht im Log `Deepforge 0.6.1 ready`. Ressourcenpaket unverändert (wie 0.5.2).

## Kombo jetzt auch im Dungeon
Die Treffer-Kombo aus den Minen zählt jetzt auch gegen Dungeon-Gegner und Bosse:

- Jeder Treffer innerhalb von 2 Sekunden erhöht die Kombo, **+3 % Schaden pro Stufe, bis +30 % ab x11**.
- Die Anzeige **„x5“, „x11“ …** erscheint wie in den Minen in der Kampfleiste, bei x5, x11 und jeder 25er-Stufe gibt es einen Ton.
- Wirst du getroffen, fällt die Kombo auf 0. Ausweichen lohnt sich also doppelt.
- Der Kombo-Rekord (Bestenliste „Kombo-Könige“) zählt Dungeon-Kombos mit.
- Blitzketten von Artefakten zählen nicht als eigener Treffer.

## Tränke-Schnellkauf (Lebenssplitter)
Lebenssplitter lassen sich jetzt überall schnell nachkaufen, nicht mehr nur einzeln bei der Händlerin:

| Wo | Wie |
|---|---|
| **Heilen-Knopf** im Hauptmenü, Kampfmenü und Dungeon-Menü | **Rechtsklick** = 1 Splitter kaufen · **Shift-Klick** = bis 12 auffüllen · Linksklick heilt wie bisher |
| **Befehl** | `/df heal kaufen` (auffüllen), `/df heal kaufen 3`, `/df heal kaufen voll` |
| **Händlerin** (`/df merchant`) | Knöpfe **1**, **5** und **Auffüllen** mit Gesamtpreis |
| **Leerer Vorrat** | Wer ohne Splitter heilen will, bekommt im Chat anklickbare Knöpfe **[1 kaufen]** und **[Auffüllen]** |

- Preis wie bisher: **250 $ pro Splitter**, mit Rettungsrabatt (Bergarbeiter im Dungeon befreit) **200 $**.
- Es wird nur so viel gekauft, wie Platz (max. 12) und Geld reichen.
- Freigeschaltet wie die Händlerin (erster Minenboss oder Dungeon-Sieg).
- **Nicht während eines Kampfes oder Dungeon-Laufs**, also vorher auffüllen.
