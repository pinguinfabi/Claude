# Deepforge – Kampf, Ausrüstung und Bossjagd

Implementierter Stand vom 27. September 2026 für Paper 1.21.8. Die bestehende Dorfwelt, Höhlen, Wirtschaft und Arbeiterproduktion bleiben die Grundlage. Diese Erweiterung verbindet Monsterjagd, dauerhaft gespeicherte Beute, Ausrüstung und wiederholbare Bosskämpfe.

Aktuelle Ergänzung: Textur-/Schienenkorrekturen, Handpositionen, Dolch-Rückenangriffe, gerichtete Panzerabwehr und Jagdaufträge sind in TEXTUR-UND-KAMPF-FIX.md beschrieben.

## Sofort testen

Mit Minecraft Java 1.21.8 auf `localhost:25565` verbinden und das neue Server-Ressourcenpaket akzeptieren. Falls noch alte Modelle erscheinen: `/df pack`.

1. `/df stats` zeigt alle Werte und die zehn Ausrüstungsplätze.
2. `/df loot` öffnet den Beutebeutel. Gefundene Ausrüstung anklicken, vergleichen und ausrüsten. Die Waffe in der Hand wird automatisch aktualisiert.
3. Über den Aufzug eine Mine betreten. Monster in den Stollen liefern Geld, gebietsspezifische Teile und gelegentlich Ausrüstung.
4. Den Bossaltar in der hinteren Kammer rechtsklicken und Normal, Veteran oder Alptraum wählen. Ein Sieg öffnet die nächste Schwierigkeit dieses Bosses.
5. Das Handbuch enthält das Beutebuch mit Dropchancen, Materialien, Siege-Zählern und gezielten Herstellungsrezepten.

## Kampfsteuerung

| Eingabe | Wirkung |
|---|---|
| Linksklick mit der Spielwaffe | Normaler Angriff; eigenes Angriffstempo und Krit-Chance |
| Rechtsklick | Waffenfähigkeit, 35 Ausdauer, 6 Sekunden Abklingzeit |
| Sneak + Rechtsklick | Ausweichschritt, 25 Ausdauer, 1,75 Sekunden Abklingzeit, kurzer Schutz gegen diese Monsterangriffe |
| `/df home` | Kampf abbrechen und heimkehren; keine Bossbelohnung |

Ausdauer regeneriert mit 12 Punkten pro Sekunde bis 100. Außerhalb eines Bosskampfs beginnt nach fünf Sekunden ohne Monster-Treffer eine langsame Heilung. Im Bosskampf gibt es keine passive Regeneration. Ein gescheiterter Versuch verbraucht keinen Eintrittsschlüssel. Beim Tod bleiben Geld, Lager und Ausrüstung erhalten; zehn Prozent der ungesicherten Erze gehen verloren.

Schwerter kombinieren einen Nahbereichsangriff mit einem 1,1 Sekunden langen Paradefenster. Hämmer treffen langsamer, verursachen viel Haltungsschaden und einen schweren Flächenangriff. Dolche haben ein höheres Grundtempo und verursachen im hinteren 120-Grad-Bereich des Gegners 65 % mehr Schaden. Speere erhöhen die normale Reichweite und besitzen einen gerichteten Stoß bis acht Blöcke. Armbrüste besitzen eine gerichtete Distanzfähigkeit bis 13 Blöcke; sie verwenden aktuell keinen Munitionstyp und keinen frei fliegenden Pfeil.

## Werte und Ausrüstung

Slots: Waffe, Nebenhand, Helm, Brustschutz, Beine, Stiefel, Ring I, Ring II, Amulett und Bergbaumodul. Ausrüstung liegt im persistenten Beutebeutel; das normale Minecraft-Inventar enthält nur ersetzbare Bediengegenstände. Rüstung ist derzeit ein virtuelles Ausrüstungssystem mit eigenen Symbolen, keine am Spielerkörper sichtbare neue Rüstungsgeometrie.

Das Charaktermenü zeigt Leben, Schaden, Rüstung, Schadensreduktion, Krit-Chance, Krit-Schaden, Angriffstempo, Haltungsschaden, Abbaugeschwindigkeit, zusätzlichen Erzertrag und Brennstoffersparnis. Lebens- und Schadenswerte verwenden dieselbe Einheit wie Minecraft: zwei Lebenspunkte entsprechen einem Herz. Das Kampf-HUD zeigt Leben, Ausdauer und Fähigkeitsabklingzeit.

Gegenstände haben feste IDs, Herkunft, Qualität von 80 bis 100 %, Seltenheit und Zusatzwerte. Verbesserungen bis +10 erhöhen Schaden, Leben und Rüstung je Stufe um acht Prozent des Grundwerts. Die Kosten steigen mit Gebiet und Verbesserungsstufe. Krit-Chance kann separat neu geschmiedet werden; andere Werte bleiben erhalten. Das Menü zeigt vor jeder Aktion deren Kosten.

Zwei ausgerüstete Rüstungs-/Schmuckteile gleicher Herkunft geben sechs Rüstung. Vier geben zusätzlich drei Schaden und zwei Leben. Obergrenzen: 60 Leben, 50 % Krit-Chance, 65 % Schadensreduktion, 3,2 Angriffe/s, 65 % Abbaubonus sowie 50 % Extra-Erz- und Brennstoffbonus. Brennstoffersparnis wirkt derzeit auf manuelles Schmelzen; die Arbeiterabrechnung bleibt unabhängig.

Favorisierte und ausgerüstete Gegenstände können weder verkauft noch zerlegt werden. Verkauf und Zerlegen haben eine Bestätigungsseite. Der Warenverkauf des Lagers verkauft keine Ausrüstung. Ein volles Minecraft-Inventar verhindert keine Beute. Der Beutel hat Seiten mit je 27 Gegenständen.

## Monster und Modelle

Sieben eigene thematische Modelle: Steinwächter, Kristallkönigin, Sporenhüter, Tiefenwächter, Magmakönig, Runenwächter und Leerenfürst. Jeder besteht aus sieben separat bewegten Teilen mit eigenen Körper-/Kerntexturen, Kopf- und Schulterformen. Arme kündigen Angriffe an, Beine bewegen sich, der Kern pulsiert und ein gebrochener Boss nimmt eine andere Haltung ein.

Technisch tragen unsichtbare Husk-Entitäten die Trefferboxen und serverseitige Logik; ItemDisplays stellen die Modelle dar. Es werden keine neuen nativen Minecraft-Entity-IDs registriert. Ohne geladenes Pack bleibt eine sichtbare Husk-Ersatzdarstellung. Für diese Monster wird Citizens nicht benötigt; Citizens wird weiterhin nur für die Spieler-Arbeiter verwendet.

In jedem Gebiet gibt es schnelle kleine Nahkämpfer, widerstandsfähige Panzerwächter und Spaltenwerfer mit angekündigtem Strahl. Sie verwenden Größenvarianten des jeweiligen Gebietsmodells. Reguläre Gegner geben gebietsspezifische Materialien und Geld. Die Ausrüstungschance beträgt 14 %; innerhalb dieses Wurfs sind 80 % ungewöhnlich und 20 % selten.

## Bossregeln

Jeder Boss hat drei Phasen: über 70 %, 35–70 % und höchstens 35 % Leben. Die letzten Phasen verkürzen Angriffspausen und können Helfer beschwören. Diese Helfer geben keine Beute, Materialien oder Geld. Sie verschwinden mit dem Kampf.

Geschlossene Deckung reduziert erlittenen Schaden auf 55 %. Angriffe und Paraden erhöhen die Haltung. Bei 100 Haltung wird der Schutz für 4,5 Sekunden gebrochen: laufende Angriffe werden unterbrochen und der Boss nimmt 135 % Schaden. Danach beginnt der nächste Zyklus. Ausweichen, Abwarten und Ausnutzen dieses Fensters sind wichtiger als ununterbrochenes Klicken.

Warnflächen bleiben während der Vorbereitung an ihrer angekündigten Position. Kegel zeigen die Schlagrichtung, ein Ring muss übersprungen oder verlassen werden, Strahlen lassen seitlich Platz, Einschläge markieren einen Kreis. Runen zeigen eine grüne sichere Gasse innerhalb des orange markierten Gefahrenkreises. Sporenfelder bleiben fünf Sekunden gefährlich. Der Tiefenwächter kann Spieler heranziehen; der Leerenfürst wechselt ab Phase zwei zusätzlich seine Position.

| Boss | Angriffsmuster |
|---|---|
| Steinwächter | Armschlag, Stampfring, Einschlag |
| Kristallkönigin | Strahl, Einschlag, Stampfring |
| Sporenhüter | Sporenfeld, Armschlag, Einschlag |
| Tiefenwächter | Strahl, Stampfring, Armschlag; Sog |
| Magmakönig | Einschlag, Stampfring, Strahl |
| Runenwächter | Runengasse, Strahl, Armschlag |
| Leerenfürst | Einschlag, Strahl, Runengasse; Positionswechsel |

Basisleben: 700 + 380 × Gebietsindex, beginnend mit Index 0. Veteran hat 165 %, Alptraum 230 % dieser Lebenspunkte. Angriffsschaden steigt pro Schwierigkeit um 30 % des Normalwerts. Die Vorwarnzeit beträgt abhängig von Phase und Modus mindestens eine Sekunde. Das Zeitlimit beträgt sechs Minuten. Arena verlassen, Tod, Logout oder Gebietswechsel beendet den Versuch ohne Belohnung.

## Seltene Beute und gezielter Fortschritt

Jeder Bossabschluss gibt einen Ausrüstungswurf: **60 % ungewöhnlich, 30 % selten, 9 % episch, 1 % legendär**. Nach neun aufeinanderfolgenden Abschlüssen ohne epischen oder besseren Hauptwurf wird der zehnte mindestens episch. Dieser Zähler wird je Gebiet gespeichert.

Zusätzlich erfolgt ein unabhängiger Wurf mit **2 %** auf den benannten legendären Bossgegenstand. Nur Alptraum hat einen weiteren unabhängigen **0,2-%-Wurf** auf dessen mythische Variante. Diese Zusatzwürfe ersetzen die garantierte Ausrüstung nicht.

| Bossgegenstand | Fester Effekt |
|---|---|
| Granitspalter | Drei Sekunden nach Ausweichen 50 % mehr Haltungsschaden |
| Prismenklinge | Kritische Treffer verursachen 210 % statt 175 % Schaden |
| Myzelmantel | 35 % weniger Schaden von Monstern des Sporen-Gebiets |
| Gezeitenspeer | 40 % mehr Schaden der Speerfähigkeit |
| Glutbrecher | 35 % mehr Schaden der Hammerfähigkeit |
| Runenschild | Parade auch mit anderen Waffen, 0,5 Sekunden längeres Fenster |
| Rissklinge | Waffenfähigkeit mit kurzem, auf freie Blöcke geprüftem Risssprung |

Benannte Waffen haben eigene farbige Modellvarianten. Normal/Veteran/Alptraum geben 2/3/4 Bossfragmente und 4/6/8 Monsterteile. Geldbelohnung: (500 + 350 × Gebietsindex) × (Schwierigkeitsindex + 1), zusätzlich Relikte. Im Beutebuch kann jeder benannte legendäre Gegenstand für 40 passende Fragmente, 30 Monsterteile und 2.000 × Gebietsstufe Dollar hergestellt werden. Seltene Zufallsdrops sind daher nicht der einzige Fortschrittsweg.

## Speicherung und Stand des Konzepts

Geld, Materialien, Beute-IDs, Ausrüstung, Favoriten, Verbesserungen, Siege, Pechzähler und Kampfbeleg werden zusammen in einer SQLite-Zeile gespeichert. Derselbe abgeschlossene Kampf kann innerhalb der gespeicherten Belegliste nicht zweimal bezahlt werden. Modelle über dem Boden sind reine Anzeigen; die Beute gehört sofort dem Profil. Ein regulärer Neustart erhält alle Funde. Alte Schema-1-Spielstände werden beim Laden auf Schema 2 erweitert; Wirtschaft, Arbeiter und Abrechnungszeit bleiben erhalten.

Der Kern des Kampf- und Beutekonzepts ist damit umgesetzt. Weiterführende Ideen aus dem Entwurf bleiben separate Erweiterungen: individuelle Rätsel je Boss, echte Armbrustmunition, saisonale Ranglisten, Gruppenexpeditionen, Affixauswahl für alle Werte und sichtbare Rüstungsmodelle am Spieler. Diese Funktionen werden nicht als bereits vorhanden dargestellt.

Die technischen Tests ersetzen keine vollständigen Kämpfe im Minecraft-Client. Schwierigkeit, Effektdichte, Modellansichten und Langzeitwirtschaft müssen mit echten Spielrunden abgestimmt werden. Details der ausgeführten Prüfungen stehen in TESTREPORT.md.
