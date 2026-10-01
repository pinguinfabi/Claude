# Neu in Deepforge 0.3.1 – Komfort-Update

Beim Serverstart steht im Log `Deepforge 0.3.1 ready`. Nur `plugins/Deepforge.jar` austauschen –
das Ressourcenpaket ist dasselbe wie in 0.3.0.

## Bohrer baut durchgehend weiter
- Endet die Überladung (oder wechselt man die Ebene), bricht der Bohrer das Erz **einfach weiter ab** statt neu anzufangen.
- Ursache: Das Abbautempo stand bisher im Bohrer-Gegenstand selbst. Jede Tempoänderung veränderte den Gegenstand,
  und Minecraft startet den Abbau neu, sobald sich das Werkzeug in der Hand ändert.
  Jetzt steckt das Tempo im Abbautempo-Wert des Spielers; der Bohrer bleibt unverändert.
- Außerhalb von Deepforge und mit anderen Gegenständen in der Hand gilt wieder das normale Tempo.

## Dungeon: genau sehen, was man bekommen hat
- Nach dem Sieg bekommt jeder Spieler **seine eigene Aufstellung**: Geld, Schmiedestaub, Relikte, Unterlagen,
  Bossfragmente, Monsterteile, Lebenssplitter, Levelaufstieg und jeden neuen Gegenstand mit Seltenheit und Stufe.
- Titel „SIEG!“ mit Kurzfassung (z. B. „+1.500 $ · 2 neue Gegenstände · Level 4“).
- Nach der Rückkehr öffnet sich das Fenster **„Dungeon-Beute“** mit allen neuen Gegenständen (anklicken = Details,
  ausrüsten, verbessern). Wieder öffnen: `/df reward` oder „Kampf & Ausrüstung“ → „Letzte Dungeon-Beute“.
- Minenbosse zeigen ebenfalls einen Titel „BOSS BESIEGT“ mit der Anzahl neuer Gegenstände.

## Beutel und Ausrüstung
- Neue, noch nicht angesehene Gegenstände tragen im Beutel **„✦ NEU“**; die Anzahl steht auch am Beutel-Knopf.
- Jeder Gegenstand zeigt einen **vollständigen Vergleich** mit der ausgerüsteten Ausrüstung:
  z. B. „▲ Schaden +2,1 · ▼ Leben −4 · ▲ Krit +1 %“.

## Hinweise beim Bergbau
- **„Bohrer heiß“** ab 80 % Hitze (einmal, mit Ton), **„Bohrer abgekühlt“**, sobald man nach dem Überhitzen weitermachen kann.
- **„Rucksack fast voll“** ab 90 %. Ist er voll, erscheint ein anklickbarer Chat-Knopf **[Lager öffnen & einlagern]**.
- **„Überladung beendet“** und **„⚡ Überladung wieder bereit“** mit Ton, damit man den Boost nicht verpasst.
- Neuer Befehl `/df lager` öffnet das Lager von überall.
