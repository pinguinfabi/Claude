# Neu in Deepforge 0.9.1 – Beutel sortieren, kein Heil-Nachkauf im Dungeon

Beim Serverstart steht im Log `Deepforge 0.9.1 ready`. Ressourcenpaket unverändert (wie 0.9.0).

## Beutel sortieren
Im Beutel (`/df loot`) gibt es rechts unten einen neuen **Sortier-Knopf** (Komparator). Jeder Klick schaltet weiter:

| Sortierung | Reihenfolge |
|---|---|
| **Neueste zuerst** | wie bisher, der letzte Fund steht oben |
| **Nach Art** | Waffe, Schild, Helm, Brust, Beine, Stiefel, Schmuck … Innerhalb jeder Art zuerst die beste Rarität, dann die höchste Aufwertung. |
| **Nach Rarität** | mythisch → legendär → episch → selten → ungewöhnlich. Innerhalb jeder Rarität nach Art. |

- Die Sortierung wird pro Spieler gespeichert.
- „Ganze Seite auswählen“, Verkaufen und Zerlegen arbeiten mit der sortierten Ansicht. Du kannst z. B. nach Rarität sortieren und alle ungewöhnlichen Teile einer Seite auf einmal zerlegen.

## Heilung: kein Nachkauf im Dungeon
- **Im Dungeon kannst du keine Lebenssplitter mehr nachkaufen**, weder per Rechtsklick noch per Shift-Klick noch per `/df heal kaufen`.
- Fülle deinen Vorrat **vor dem Start** auf, z. B. im Dungeon-Menü.
- Lebenssplitter, die du im Dungeon findest (Monster, Truhen), gibt es weiterhin.
- Außerhalb von Dungeons bleibt alles wie bisher.
