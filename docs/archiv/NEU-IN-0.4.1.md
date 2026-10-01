# Neu in Deepforge 0.4.1

Beim Serverstart steht im Log `Deepforge 0.4.1 ready`. Ressourcenpaket unverändert (wie 0.4.0).

## Chat-Spam „Prüfe Werkzeugstufe, Rucksackfüllung und Bohrerhitze.“ behoben
- Seit 0.3.1 lag das Bohrertempo auf dem allgemeinen Abbautempo des Spielers. Dadurch brach der Bohrer auch
  **Stein und Wände** sofort – jeder Versuch schrieb die Meldung in den Chat.
- Jetzt gilt das Bohrertempo nur noch für **Erzadern** (über die Abbau-Effizienz, die Minecraft nur beim passenden
  Werkzeug anwendet). Stein und Wände brauchen wieder normal lange.
- Das Erz wird beim Ende der Überladung weiterhin **nicht** neu angefangen.
- Hinweise erscheinen nur noch kurz in der Aktionsleiste statt im Chat.

## Dungeon: Zuschauerplatz
- Besiegte Spieler wurden in der Bosshalle **in** den erhöhten Amethyst-Boden gesetzt und hingen dort fest.
  Der Platz wird jetzt immer so gewählt, dass Füße und Kopf frei sind (auf dem Amethyst).
