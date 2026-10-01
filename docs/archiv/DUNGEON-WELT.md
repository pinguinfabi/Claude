# Runengewölbe als Teil der Welt

## Einstieg im Dorf

Hinter dem Markt führt der Weg zum **Runengewölbe**: ein steinernes Portalhaus mit hohem Kupferdach, beleuchtetem Runenfenster, Säulen, Seelenlaternen, Sitzbänken und einem Startpult. Rechtsklick auf das Pult öffnet das Dungeonmenü. Wegweiser führen vom hinteren Dorfweg zum Eingang. Das Pult steht auf dem eigenen Grundstück bei lokal X=0, Y=201, Z=-52.

Der Eingang wird bestehenden Dörfern automatisch hinzugefügt. Die Migration ändert nur die vorgesehene Oberfläche hinter dem Markt; Häuser, Minen, Ausrüstung und Spielstand bleiben erhalten.

Das Menü nutzt denselben 54-Slot-Texturrahmen wie die übrigen Deepforge-Menüs und vorhandene eigene Itemmodelle. Es zeigt Gruppenbereitschaft, Gebiet, Level, Schwierigkeit, Bossleben, Beutechancen, Heilhinweis und die Route durch die Hallen. `/df dungeon` bleibt als direkter Zugang verfügbar. Ohne aktives Ressourcenpaket funktioniert das Menü mit normalem Inventarhintergrund.

## Zusammenhängender Lauf

Beim Start reist die Gruppe einmalig in ihre private Instanz. Danach sind die drei Hallen durch echte, überdachte Gänge verbunden:

1. **Halle der Runen:** Steinarchitektur, Regale, Säulen, Hängelampen. Nach Welle 2 öffnet die gelöste Runenfolge das erste Tor.
2. **Siegelgalerie:** Kupferdetails und dunkler Stein. Nach Welle 4 öffnen gemeinsam aktivierte Bodenplatten den Weg zum Heiligtum.
3. **Herz des Gewölbes:** schwarze Steine, Kristalldetails und die finalen Wellen. Der Endboss behält seine erhöhte Lebensmenge, Angriffe und Rückenkonter.

Die bestehenden Gebietsthemen verändern die Akzentblöcke. Pro Lauf gibt es weiterhin fünf bis acht Wellen entsprechend dem Dungeonlevel; zusätzliche hohe Wellen finden im Heiligtum statt.

Ein gelöstes Rätsel öffnet sichtbare Gittertore. Alle derzeit online kämpfenden Gruppenmitglieder müssen die nächste Halle betreten, bevor sich der Durchgang schließt und der nächste Kampf beginnt. Ein einzelner Spieler kann die Gruppe nicht hinter dem Tor zurücklassen. Rückkehrer nutzen den aktuellen Kontrollpunkt; die bestehende 60-Sekunden-Regel bleibt erhalten.

**Überlebende werden nach Wellen nicht mehr teleportiert.** Sie behalten ihre Position. Nur Eintritt, Austritt, Wiederbelebung, Wiederanmeldung und eine Sicherung bei Verlassen der Instanzgrenzen setzen eine Position. Geschlossene Hallen lassen sich auch mit der Teleportfähigkeit nicht vorzeitig betreten.

## Runensegen als Entscheidung im Lauf

Nach jedem der beiden Rätsel erscheinen drei beschriftete Schreine vor dem geöffneten Tor. Jeder Spieler wählt unabhängig per Rechtsklick genau einen Segen pro Halle:

| Schrein | Wirkung |
|---|---|
| Kraft | +8 % Schaden im laufenden Dungeon; zweimal gewählt +16 % |
| Schutz | -8 % eingehender Dungeonschaden; zweimal gewählt -16 % vor der normalen Rüstung |
| Quelle | Sofort 35 % des maximalen Lebens heilen; bei vollem Leben wird keine Wahl verbraucht |

Der Segen wird weder als handelbarer Gegenstand noch als dauerhafte Währung vergeben. Abbruch und Neustart setzen ihn zurück. Wiederholtes Anklicken vervielfacht die Wirkung nicht. Das Wählen eines Segens löst keine Waffenfähigkeit aus.

Überlebende erhalten nach einer Welle 15 % ihres maximalen Lebens zurück, ohne ihre Position zu verlieren. Besiegte Spieler kehren am aktuellen Kontrollpunkt mit 50 % Leben zurück. Die separate Lebenssplitter-Heilung bleibt nutzbar. Dadurch erhalten Heilung und die Schreinwahl Bedeutung für den weiteren Lauf.

## Weiterführung des Konzepts

Der Dungeon ist jetzt ein Weg mit Kämpfen, zwei Torzielen und persönlichen Entscheidungen zwischen den Hallen. Levelaufstieg und Abschlussbeute bleiben am vollständig gewonnenen Lauf gebunden.

Im anschließenden [Abenteuer-Update](ABENTEUER-UPDATE.md) wurden drei gebaute Seitenkammern ergänzt: Elite-/Fluchprüfung, Gefangenenrettung und eine verschlossene Schatzkammer mit Schlüssel aus der zweiten Halle. Die Zusatzbelohnung wird erst beim erfolgreichen Abschluss gespeichert. Alternative zufällige Raumfolgen und weitere Tor-Rätsel bleiben spätere Erweiterungen. Die Hauptroute verwendet weiterhin drei feste Hallen mit variierender Gegnerzusammensetzung und steigenden Werten.

## Prüfung

Automatisierte Wegsuche prüft alle sieben Gebietspaletten, die Erreichbarkeit sämtlicher Hallen und Rätsel, geschlossene Tore, den geschützten Wartebereich und den Dorfzugang. Weitere Tests prüfen persönliche Segen, Einmalwahl, Höchstwerte und das Ende der Boni mit dem Lauf.

Die Paper-Diagnose baut die echte Instanz, öffnet und schließt die Tore, prüft die Laufkorridore und erzeugt acht Wellen mit simulierter Vierergruppe. Anschließend werden Gegner, Beschriftungen und Chunk-Tickets bereinigt. Diese Diagnose spielt keinen echten Mehrspieler-Dungeon; die Menüdarstellung und das Spielgefühl müssen im Minecraft-Client abgenommen werden. Die mitgelieferte Geometrievorschau stammt aus dem Bauplan und ist keine Spielaufnahme.
