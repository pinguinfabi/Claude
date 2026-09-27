# Dungeonlevel, skalierende Gruppen und Lebenssplitter

## Fortschritt

Jeder vollständig gewonnene Dungeon erhöht dein dauerhaftes Dungeonlevel um genau **1**. Verlieren, Aussteigen und Abbrechen geben keinen Aufstieg. Bestehende Siege werden beim Laden eines älteren Spielstands angerechnet: Startlevel = 1 + bisherige Dungeon-Siege.

In Gruppen bestimmt das **höchste Dungeonlevel** den nächsten Lauf. Zusätzlich skalieren Gegnerleben, Schaden und Anzahl mit der ursprünglichen Gruppengröße. Ein schwächerer Partyleiter setzt die Schwierigkeit nicht herab. Alle verbliebenen Teilnehmer steigen bei Erfolg jeweils um einen Level auf; ein niedrigeres Mitglied springt nicht auf das Level des stärksten Spielers.

Gebiet und Normal/Veteran/Albtraum bleiben eigene Auswahlmöglichkeiten. Die persönliche Stufe wächst unabhängig davon. Dungeonmenü, Bossleiste und Gegnernamen zeigen die Laufstufe. Die Stufe wird beim Start festgehalten und ändert sich im laufenden Kampf nicht, wenn jemand geht.

## Neue Herausforderungen

| Ab Level | Änderung |
|---|---|
| 1 | Fünf Wellen, Sprenger, Strahlenwirker, Heilrufer und Endboss |
| 2 | Wechselnde Kampfbedingung bei jedem nächsten Level |
| 3 | Elitegegner mit mehr Leben und Schaden sowie sichtbaren Partikeln |
| 4 | Rissjäger mit angekündigtem, gerichtetem Ansturm |
| 6 | Endboss ruft bei 66 % und 33 % Leben zusätzliche Gegner |
| 11 | Sechs Wellen |
| 21 | Sieben Wellen |
| 31 | Acht Wellen; Level und Werte steigen danach weiter |

Die Bedingungen rotieren: **Rudel** bringt zusätzliche Monster, **Raserei** erhöht Bewegungstempo und Angriffsfrequenz, **Elitepatrouille** erhöht den Eliteanteil, **Runensturm** gibt dem Boss eine zweite angekündigte Explosionsfläche. Gegnermischungen unterscheiden sich zwischen Läufen.

Gegnerleben wächst um 10 % des Ausgangswerts pro Level. Schaden steigt langsamer über eine logarithmische Kurve. Warnzeiten bleiben mindestens 1,1 Sekunden lang. Gruppen erhöhen das Leben um 85 % pro zusätzlichem Mitglied und Schaden um 6 %; außerdem erscheinen mehr Gegner. Erhöhte Schwierigkeiten wirken zusätzlich. Aktuelles Bossbalancing, Rundumschlag gegen Rückenangriffe und erhöhte Ausgangswerte: [BOSS-BALANCE.md](BOSS-BALANCE.md). Zeitlimit pro Lauf: 30 Minuten.

Monster werden in begrenzten Gruppen nachgeladen: maximal 8 gleichzeitig solo, 10 zu zweit, 12 zu dritt oder 14 zu viert. Noch ausstehende Gegner erscheinen in der Bossleiste. Eine Welle ist erst abgeschlossen, wenn auch die Warteschlange besiegt ist. Dadurch führen hohe Level nicht zu unbegrenzt vielen gleichzeitig aktiven Modellen.

## Beute wächst mit

Gewonnene Gegenstände tragen ihre Dungeonstufe im Namen und Tooltip. Schaden, Leben und Rüstung wachsen um 7,5 % des gerollten Ausgangswerts pro Lauflevel. Bergbauboni wachsen langsamer. Krit- und Tempowerte behalten ihre bisherigen Begrenzungen. Höherstufige ausgerüstete Dungeonbeute hebt die bisherige 60-LP-Obergrenze schrittweise an, maximal bis zur technischen 1024-LP-Grenze; tatsächliches Leben kommt weiterhin aus Ausrüstung.

Geld wächst um 12 % des Grundbetrags pro Lauflevel; dazu kommen mehr Staub und Forschungsnotizen. Chancen auf epische, legendäre und mythische Beute steigen mit begrenzten Zuschlägen. Die aktuellen seltenen Chancen und die konkrete Geldprämie stehen vor dem Start im Menü. Bei vollem Beutebeutel wird weiterhin nur der neue Drop in Staub umgewandelt.

Beispiel für Gebiet 1, Normal, jeweils ohne Elitebonus:

| Dungeonlevel | Wellen | Bossleben solo | Bossleben zu viert | Geld pro Person |
|---|---:|---:|---:|---:|
| 1 | 5 | 6.000 | 21.300 | 600 $ |
| 11 | 6 | 12.000 | 42.600 | 1.320 $ |
| 21 | 7 | 18.000 | 63.900 | 2.040 $ |
| 31 | 8 | 24.000 | 85.200 | 2.760 $ |

Levelaufstieg, Beute, Geld und Abschluss-Heilitems werden gemeinsam gespeichert. Eine wiederholte Verarbeitung desselben Sieges vergibt keine doppelte Belohnung.

## Heilung im Kampf

**Lebenssplitter** besitzen ein eigenes grünes Kristallmodell. Benutzen: Kristall in die Haupthand nehmen und rechtsklicken, `/df heal` eingeben oder die Heilungs-Schaltfläche im Handbuch verwenden. Bei vollem Inventar funktioniert der Befehl weiterhin; der echte Vorrat liegt im Spielerstand.

- Heilung: **4 LP + 35 % des maximalen Lebens**, höchstens bis zum vollen Leben.
- **20 Sekunden gemeinsame Abklingzeit**, auch über Abmelden und Serverneustarts hinweg.
- Maximal **12 Splitter** im Vorrat; Anzeige im Inventar und Kampf-HUD.
- Ein Startsplitter wird einmalig für neue beziehungsweise alte Spielstände ohne Heilsystem angelegt.
- Reguläre Minenmonster: 10 % Chance auf einen Splitter. Normale Minenbosse geben zwei.
- Dungeonmonster: 12 %, Eliten: 40 %. Der Fund geht an das aktive Gruppenmitglied mit dem niedrigsten Vorrat, maximal drei solcher Funde pro Mitglied und Lauf.
- Jeder abgeschlossene Dungeon gibt zusätzlich zwei Splitter bis zum Vorratslimit.
- Volles Leben, Tod und die Wartephase nach einer Niederlage verbrauchen keinen Splitter. Besiegte Gruppenmitglieder können sich damit nicht selbst wiederbeleben.

Ein leerer Kristall bleibt als Bedienhilfe im Inventar. Aufteilen oder Verschieben des angezeigten Stapels vervielfacht den gespeicherten Vorrat nicht.

## Prüfung und Grenzen

Automatisierte Tests prüfen Migration, Aufstieg, gruppenabhängige Skalierung, Spawnobergrenzen, Beutewerte, Heilung, Abklingzeiten sowie Speicherung über Neustarts. Der erweiterte Serverdiagnoselauf erzeugt acht Wellen eines Level-31-Dungeons mit einer simulierten Vierergruppe und prüft Nachspawns, vier Gegnerarten, Eliten, Boss, Runen, Heilitem und Bereinigung. Er steuert keine echten Spieler und ersetzt keinen gemeinsamen Durchlauf im Minecraft-Client.

Der Ausbau schafft eine fortlaufende Werte- und Beuteprogression. Inzwischen ersetzen drei verbundene Hallen mit Toren und Runensegen die einzelne Arena; siehe [DUNGEON-WELT.md](DUNGEON-WELT.md). Weitere Raumvarianten, Rätsel und Bosstypen bleiben kommende Inhaltsupdates. Langfristiges Balancing muss durch Spielen überprüft werden.
