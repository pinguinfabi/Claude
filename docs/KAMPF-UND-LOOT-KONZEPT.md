# Deepforge – Ausrüstung, Monster und Bossjagd

Gesamtkonzept mit Umsetzungsstand vom 27. September 2026. Der Kern ist jetzt im Plugin umgesetzt: Ausrüstungswerte und zehn Slots, Beutebeutel, fünf Waffenarten, sieben animierte Gebietsmodelle, Bossphasen, drei Schwierigkeiten, seltene Drops, Pechschutz und Herstellung. **Die verbindliche Beschreibung des tatsächlich implementierten Standes ist KAMPF-UPDATE.md.** Die folgenden Abschnitte bewahren auch weiterführende Ideen; insbesondere Munition, individuelle Bossrätsel, Eliteaffixe und Ranglisten sind noch Erweiterungsziele.

Seit dem anschließenden Korrekturupdate sind außerdem Dolch-Rückenangriffe, gerichteter Panzerschutz und persistente, wiederholbare Jagdaufträge umgesetzt. Details: TEXTUR-UND-KAMPF-FIX.md.

## Ziel und Spielkreislauf

Spieler verdienen Ingame-Geld, indem sie Erze und Materialien fördern, hochwertige Waren herstellen, Aufträge erfüllen und wertvolle Beute finden. Kampfausrüstung eröffnet gefährlichere, profitablere Gebiete. Verbesserungen des Betriebs finanzieren wiederum die Vorbereitung auf schwierigere Kämpfe.

Der erweiterte Kreislauf lautet: Mine erkunden → Erze und Monsterteile sammeln → Ausrüstung herstellen oder finden → Build verbessern → Bossmechaniken meistern → seltene Gegenstände und Rezepte erhalten → behalten, zerlegen oder verkaufen → nächsten Schwierigkeitsgrad angehen.

## Ausrüstung und Werte

Slots: Hauptwaffe, Nebenhand, Helm, Brustschutz, Hose, Schuhe, zwei Ringe, Amulett und separates Bergbauwerkzeug. Ein Charaktermenü zeigt Gesamtwerte, Herkunft der Boni und Veränderungen beim Gegenstandsvergleich.

Kampfwerte: maximales Leben, Waffenschaden, Angriffstempo, kritische Trefferchance, kritischer Zusatzschaden, Rüstung, Ausdauer und Haltungsschaden. Fähigkeiten besitzen eigene Abklingzeiten. Gebietsresistenzen und Spezialeffekte werden nur angezeigt, wenn sie relevant sind.

Wirtschaftswerte: Abbaugeschwindigkeit, Chance auf zusätzliches Erz, Werkzeughitze, Rucksackkapazität und Verarbeitungseffizienz. Gute Bergbauausrüstung kann deshalb auch ohne hohen Kampfschaden wertvoll sein. Ein universeller Glückswert, der jeden Drop erhöht, ist zunächst nicht vorgesehen; Jagdboni nennen ausdrücklich die betroffene Beutekategorie.

Startwerte für die Balance: kritische Trefferchance maximal 50 %, gesamte Schadensreduktion maximal 65 %, Lebensraub nur mit kurzer interner Abklingzeit und begrenzt gegen beschworene Kleingegner. Ausweichschritte kosten Ausdauer. Endgültige Grenzen werden mit echten Kämpfen erprobt.

## Waffen und Builds

- Schwert: ausgewogen, präzises Parieren und Gegenangriff.
- Zweihandhammer: langsam, hoher Haltungsschaden, öffnet Schwachstellen schneller.
- Dolche: schnelle Treffer, Bonus aus günstiger Position, geringe Reichweite.
- Speer: Reichweite, gezielte Stiche gegen freigelegte Kerne.
- Armbrust: Distanzschaden mit Nachladefenster und herstellbarer Munition.

Es gibt gezielte Builds wie einen standfesten Wächter, einen mobilen Krit-Kämpfer, einen Hammer-Brecher und einen besonders ertragreichen Bergarbeiter. Seltene Effekte verändern die Spielweise. Eine Waffe höherer Seltenheit ist nicht automatisch für jeden Build besser.

Ein Gegenstand besitzt eine feste Basis, Gebietsstufe, Seltenheit und bis zu drei Zusatzwerte. Benannte Bossgegenstände tragen zusätzlich einen festen Spezialeffekt. Wertebereiche bleiben begrenzt, damit ein guter Fund lange nützlich bleibt.

Beispiel: **Granitspalter**, legendärer Zweihandhammer des Steinwächters. Hoher Haltungsschaden, langsame Schläge und die Fähigkeit „Bruchlinie“: Nach einem erfolgreichen Ausweichen verursacht der nächste schwere Schlag eine kurze Bodenwelle. Der Granitspalter ist inzwischen vorhanden; umgesetzt ist ein dreisekündiger Bonus auf Haltungsschaden nach dem Ausweichen. Die beschriebene Bodenwelle bleibt eine mögliche Erweiterung.

## Beute und seltene Funde

Jeder gültige Bossabschluss belohnt Material, Bossfragmente und einen Ausrüstungswurf. Erste Verteilung für diesen einen Ausrüstungswurf: 60 % ungewöhnlich, 30 % selten, 9 % episch, 1 % legendär. Diese vier Chancen ergeben zusammen 100 %.

Davon getrennt gibt es einen zusätzlichen Wurf auf einen benannten Bossgegenstand, zunächst beispielsweise 2 %. Der höchste Schwierigkeitsgrad kann außerdem einen eigenständigen mythischen Gegenstand mit zunächst 0,2 % Chance vergeben. Diese Prozentwerte sind inzwischen im aktuellen Server umgesetzt; sie bleiben anhand echter Spielrunden abstimmbar. Das Beutebuch zeigt, ob ein Wurf zusätzlich erfolgt und auf welchen Modus sich seine Chance bezieht.

Ein extrem seltener Fund soll besonders aussehen und einen interessanten Effekt haben. Kein solcher Zufallsfund ist für den nächsten normalen Gebietsabschluss erforderlich. Nach neun Bossabschlüssen ohne epischen oder besseren Ausrüstungswurf wird der zehnte entsprechend aufgewertet. Bossfragmente ermöglichen daneben gezieltes Herstellen ausgewählter Gegenstände; glänzende Varianten und perfekte Zusatzwerte bleiben eigene Sammelziele.

Schlechte oder doppelte Ausrüstung lässt sich gegen Materialien zerlegen oder zu nachvollziehbaren NPC-Preisen verkaufen. Bei vollem Inventar gelangt Beute in ein Abholfach. Ausgerüstete, gesperrte und favorisierte Gegenstände werden vom Sammelverkauf ausgeschlossen.

## Gegner in den Minen

Jedes Gebiet erhält eine kleine, unterscheidbare Gegnergruppe. Beispiel Eisenmine: Erzkrabbler greifen in kleinen Gruppen an; gepanzerte Grubenwächter schützen ihre Vorderseite; Spaltenwerfer markieren den Einschlag ihrer Geschosse. Elitevarianten kombinieren höchstens zwei Eigenschaften und besitzen erkennbare Modellelemente.

Monster liefern gezielte Herstellungsmaterialien: Panzerplatten, Kristallsplitter, Pilzkerne, Tiefenfasern oder Glutherzen. Das Beutebuch nennt die Quelle und spätere Verwendung. Seltene Adern, Materialdepots und optionale Nebenkammern ergänzen die Jagd. So gibt es auch zwischen Bossversuchen sinnvolle Ziele.

## Schwierige, nachvollziehbare Kämpfe

Der aktuelle Steinwächter hat 40 Lebenspunkte. Das bestehende Schwert wächst pauschal mit der Upgrade-Stufe; die Bosse verwenden einen gemeinsamen Husk-Körper und ein einfaches Nahkampf-/Flächenmuster. Der Ausbau muss deshalb Kampflogik, Ausrüstung und Bossverhalten zusammen ersetzen.

Ziel für normale Gebietsbosse: ungefähr zwei bis vier Minuten mit passender Ausrüstung. Schwierigkeit entsteht durch Richtung, Timing, Ausdauerverwaltung und Prioritäten. Gefährliche Treffer werden mit Animation, Ton und Bodenmarkierung angekündigt. Ein normaler Fehler ist verkraftbar; wiederholtes Ignorieren der Mechaniken führt zuverlässig zur Niederlage.

Bosszustände: beobachten → Angriff ankündigen → Angriff ausführen → Erholungsfenster. Die Schadensberechnung löst nur im angekündigten Zeitfenster und in der sichtbaren Trefferfläche aus. Angriffe dürfen sich nicht zu unvermeidbaren Kombinationen überlagern. Große Modelle benötigen passende Trefferbereiche. Beschworene Gegner sind begrenzt und verschwinden beim Kampfende.

## Steinwächter – vollständiger Musterkampf

Modell: massiver Golem aus Felsplatten, zwei schweren Armen und einem sichtbaren Glutkern. Zustände: ruhen, aufrichten, gehen, Schlag vorbereiten, zuschlagen, stampfen, Kern freilegen, zusammenbrechen.

Phase 1, 100–70 % Leben: Der Boss hebt einen Arm an und schlägt nach einer klaren Warnung in einen Kegel vor sich. Ein Stampfer erzeugt einen wandernden Ring, dem man ausweichen oder über den man springen kann. Nach schweren Angriffen bleibt der Kern kurz erreichbar.

Phase 2, 70–35 %: Felstrümmer werden durch Schatten und Geräusche angekündigt. Zwei Erzkrabbler stören die Bewegung. Schildplatten nehmen Haltungsschaden; ein gebrochener Schutz legt den Kern für ein größeres Schadensfenster frei. Die Arena bleibt auf mehreren Wegen durchquerbar.

Phase 3, unter 35 %: Kürzere Pausen, kombinierte Schlagfolgen und wechselnde Gefahrenzonen. Die Vorwarnungen bleiben lesbar. Unterbrochene Angriffe und richtig genutzte Kernfenster belohnen Können. Ein festes Zeitlimit verhindert endloses Umkreisen, wird aber erst nach Messung realer Kämpfe eingestellt.

## Sieben Bossidentitäten

| Boss | Eigene Erscheinung | Zentrale Mechanik | Beispielbeute |
|---|---|---|---|
| Steinwächter | Felsgolem mit Kern | Schutz brechen, Stampfwellen | Granitspalter |
| Kristallkönigin | Schwebendes Kristallwesen | Strahlenlinien, Kristallknoten, Splittersalven | Prismenklinge |
| Sporenhüter | Schweres Pilzwesen | Giftflächen, Sporenknospen, kurze sichere Routen | Myzelmantel |
| Tiefenwächter | Gepanzerte Tiefenkreatur | Strömungsstöße, Harpunenlinien, Unterbrechungen | Gezeitenspeer |
| Magmakönig | Lavakern mit Basaltpanzer | Wandernde Hitzezonen, Abkühlfenster | Glutbrecher |
| Runenwächter | Antiker Steinwächter mit Runenringen | Runenreihenfolgen, wechselnde Schutzseiten | Runenschild |
| Leerenfürst | Schwebendes Wesen mit getrennten Panzerteilen | Angekündigte Ortswechsel, Raumzonen, Täuschbilder | Rissklinge |

## Schwierigkeitsgrade und Arenaregeln

Normal öffnet den nächsten Spielabschnitt. Veteran erweitert Angriffskombinationen und verbessert die Auswahl der Beute. Alptraum bietet zusätzliche Mechaniken und besondere Beute. Lebenspunkte und Schaden allein unterscheiden die Stufen nicht ausreichend.

Zum Start erhält der Spieler eine Übersicht über empfohlene Ausrüstung, Beute und Mechaniken. Verlassen, Tod, Abbruch oder Neustart beendet den Kampf kontrolliert. Ein besiegter Boss kann nur einmal belohnt werden. Alte Adds, Projektile, Modelle und Warnflächen werden entfernt. Beschworene Adds vergeben keine endlos farmbare Hauptbeute.

## Geldkreislauf und langfristige Ziele

Einnahmen: Erzverkauf, Barren, Materialaufträge, Bossmaterialien und überschüssige Ausrüstung. Ausgaben: gezielte Verbesserungen, das Neuwürfeln eines ausgewählten Zusatzwertes, Verbrauchsgegenstände, Verarbeitung und Betriebsausbau. Verbesserungen können teuer sein, zerstören aber keine wertvollen Gegenstände zufällig.

Langfristige Ziele sind vollständige Ausrüstungssätze, passende Zusatzwerte, alle Bosswaffen, effiziente Produktionsketten, Beutebuch-Einträge und persönliche Bestzeiten. Freiwillige Herausforderungen können Kämpfe ohne Heilung oder mit schwächerer Ausrüstung belohnen. Es gibt keine notwendige tägliche Anwesenheitsserie und keine Pflicht, ultrarare Waffen für normale Fortschritte zu besitzen.

## HUD und Menüs

Im Kampf: Spielerleben, Ausdauer, aktive Fähigkeit und deren Abklingzeit. Oben: Bossleben, Phase und vorbereiteter Angriff. Kritische Warnungen erscheinen zusätzlich direkt in der Welt. Beim Abbauen stehen Ertrag, Rucksack und Hitze im Vordergrund.

Neue Menüs: Charakter mit Ausrüstungsplätzen; Gegenstandsvergleich; Beutebuch; Schmiede für gezielte Verbesserungen; Bossauswahl mit Schwierigkeit und Dropchancen. Seltene Funde erhalten ein kurzes Modell-/Sound-Feedback und einen Eintrag im Beuteprotokoll.

## Technischer Ansatz für Paper 1.21.8

Eigene Monstererscheinungen werden aus Ressourcenpaket-Modellen und animierten ItemDisplays aufgebaut; Pluginlogik steuert Verhalten und Trefferbereiche. Eine bestehende Minecraft-Entity kann verdeckt Bewegung oder Treffererkennung tragen. Das ergibt eigene Monster im Spiel, ohne neue native Client-Entity-Typen vorauszusetzen. Paper unterstützt Display-Transformationen und interpolierte Bewegung: [Display entities](https://docs.papermc.io/paper/dev/display-entities/).

Monstertechnik und Citizens-Arbeiter bleiben getrennt. Der erste Boss dient als vollständiger Techniktest für Modelle, Animation, Hitbox, Phasenwechsel, Loot und Aufräumen. Die Zahl der Modellteile und aktiven Gegner wird begrenzt; ein Lasttest entscheidet über die endgültigen Grenzen.

Jeder Ausrüstungsgegenstand braucht eine dauerhafte ID, gespeicherte Werte und eine eindeutige Besitzer-/Inventarzuordnung. Die heutige Kit-Aktualisierung darf gefundene Waffen nicht überschreiben. Bossabschluss und Beute müssen atomar gespeichert werden. Wiederholte Todesereignisse oder ein Serverneustart dürfen keine doppelte Belohnung erzeugen. Ein Geldtransfer oder späterer Spielerhandel setzt zusätzliche Transaktionsregeln voraus und gehört nicht zum ersten Ausbau.

## Umsetzung in sinnvoller Reihenfolge

1. Gegenstands- und Stat-System einschließlich Migration, Ausrüstungsmenü und Schutz gegen Verlust/Duplizierung.
2. Ein vollständiger Steinwächter mit eigenem Modell, Animation, drei Phasen und Beutetabelle.
3. Zwei bis drei neue normale Gegner und passende Herstellungsmaterialien für die Eisenmine.
4. Erstes Spieltesting: Lesbarkeit, Schwierigkeit, Kampfzeit, Dropqualität und wirtschaftlicher Ertrag pro Stunde.
5. Übertragung auf die weiteren sechs Gebiete, danach Veteran und Alptraum.

Dieser Entwurf erweitert den Spielumfang; er behauptet keine bereits ausgelieferten neuen Monster, Werte oder Gegenstände.

## Ergänzung: Forschung und Betrieb

Der nächste umgesetzte Ausbau verbindet echte Arbeiterwege unter Tage, Schichtverwaltung, fünf Forschungszweige, neue Materialaufträge, 21 erkundbare Fundkisten und mehrstufige Erzsammlungen. Der verbindliche Umfang steht in ARBEITER-UND-INDUSTRIE.md. Die weiterführenden Ideen dieses Dokuments bleiben davon getrennt.
