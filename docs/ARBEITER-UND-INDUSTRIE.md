# Deepforge: Arbeiter, Forschung und Erkundung

## Jetzt spielbar

**Bergarbeiter unter Tage.** Ein Bergarbeiter läuft vom Dorf zum Förderturm, benutzt den Aufzug in sein zugewiesenes Gebiet und folgt einem erreichbaren Weg zu einer echten Erzader. Dort richtet er sich zum Erz aus, schlägt mit seiner Spitzhacke zu und erzeugt Steinpartikel und Schlaggeräusche. Anschließend trägt er Erz zum Grubendepot am Eingang zurück und beginnt an einer anderen Ader. Der alte Arbeitsfelsen im Dorf ist kein Arbeiterziel mehr. Die Aufzugsfahrt verbindet dieselben getrennten Ebenen wie der Spieleraufzug; es wurde kein neuer Treppenschacht durch die Welt gebohrt.

Schmelzer gehen an die Schmelze, Händler an den Markt. Arbeiter rechtsklicken oder `/df crew` öffnen: Gebiet, Erfahrungsminuten, Leistung, Lohn und aktueller Status sind sichtbar. Fehlendes Budget, fehlender Brennstoff, volle Lager und fehlende Eingangswaren werden benannt. Schichten lassen sich pausieren. Die Pause gilt auch bei Offline-Produktion; Lohn und Brennstoff werden dann nicht verbraucht. „Mine besuchen“ bringt den Spieler zum zugewiesenen Mineneingang.

Im Betriebsmenü gibt es zusätzlich **100 $ Budget einzahlen** und **20 Brennstoff für 20 $**. Die bisherigen größeren Versorgungskäufe bleiben erhalten.

**Fünf Forschungszweige mit je fünf Stufen.** `/df research`, Handbuch oder Betriebsmenü:

| Forschung | Wirkung je Stufe |
|---|---|
| Bohrtechnik | +8 % Abbaugeschwindigkeit |
| Kühlkreislauf | +1 Kühlung pro Sekunde in Ruhe und −0,4 Hitze je Erzblock |
| Arbeiterschulung | +1 produzierte/verarbeitete/verkaufte Einheit je Arbeiter und Arbeitsminute; Produktionsgrenzen gelten weiter |
| Handelsnetz | +5 % Erlös bei neuen Lieferaufträgen und automatischen Händlerverkäufen |
| Logistik | +240 Lagerplätze, +1 Stunde Offline-Limit; Gesamtlimit weiterhin 24 Stunden |

Forschung kostet Geld, Forschungsunterlagen und Eisenbarren. Höhere Forschungsstufen verlangen höhere Werkzeugstufen. Die Boni wirken in der tatsächlichen Abbau- und Produktionsberechnung. Angezeigte Werkzeugwerte berücksichtigen die Änderungen.

**Drei dauerhafte Auftragsreihen.** `/df contracts` oder Handel → Auftragstafel. Erzlieferungen verbrauchen Erz aus Rucksack und Lager; Barrenaufträge eingelagerte Barren; Jagdmaterialaufträge Monsterteile. Jede Reihe hat ihren eigenen Fortschritt und wechselt zwischen erschlossenen Gebieten. Es gibt kein Zeitlimit. Belohnungen sind Geld und Forschungsunterlagen. Jede fünfte abgeschlossene Lieferung zählt weiter für die Reliktbelohnung. Bereits erledigte Auftragsnummern können nicht erneut bezahlen.

**21 Fundkisten in den echten Minen.** Drei pro Gebiet, in seitlichen Stollen. Sichtbares Kistenmodell und schwebender Hinweis; per Rechtsklick bergen. Jede Kiste gibt Geld, drei Forschungsunterlagen und Staub. Alle drei Funde eines Gebiets ergeben ein zusätzliches Relikt. Jede Fundstelle wird pro Spieler genau einmal belohnt und bleibt über Neustarts hinweg gespeichert. `/df expeditions` zeigt Fortschritt und Gebietszugang. Andere Spieler können eigene Funde nicht öffnen; während eines Bosskampfs ist Bergen gesperrt.

**21 Sammlungsränge.** Jedes der sieben Erzgebiete besitzt Ziele bei 500, 2.000 und 10.000 selbst geförderten Erzen. Höhere Ränge geben zusätzliche Relikte und Unterlagen. Bereits abgeholte alte 500er-Belohnungen zählen als Rang 1 und werden nicht noch einmal ausgezahlt.

## Zusammenspiel und nächste Ziele im Spiel

Zuerst selbst fördern und erste Ausrüstung verbessern. Anschließend den Gebietsboss besiegen und Arbeiter freischalten. Unterwegs Seitenstollen erkunden und Fundkisten bergen. Erze für Verkauf, Barren für Forschung oder Lieferung und Monsterteile für Ausrüstung beziehungsweise Aufträge abwägen. Forschung, Arbeiterausbildung und Lagerausbau verbessern die Einnahmen. Danach neue Gebiete, höhere Sammlungsränge und schwierige Bossbeute angehen.

Die sichtbare Arbeit und die wirtschaftliche Minutenabrechnung sind bewusst getrennt. Es gibt keine zusätzliche Gutschrift pro Spitzhackenschwung und keine Doppelproduktion. Online und offline gilt dieselbe deterministische Verarbeitung mit Brennstoff-, Budget-, Lager- und Offline-Grenzen. Die NPCs entfernen nicht die Erzblöcke, die ein Spieler selbst abbauen kann. Physischer Erztransport und Förderbandinventare sind noch kein eigener Warenbestand.

## Prüfungen und Grenzen

Automatisierte Prüfungen decken gültige Wege in allen sieben Minen, erreichbare und getrennte Fundstellen, Auftragsverbrauch, doppelte Klicks, Gebietssperren, Forschungskosten, alte Sammlungsbelohnungen, Online-/Offline-Gleichheit und Neustart-Persistenz ab. Hinzu kommen separate Tests mit einem echten Citizens-NPC und den Fund-Entities auf dem lokalen Paper-Server. Der aktuelle Prüfbericht enthält die gemessenen Ergebnisse.

Dieses Update erweitert den tatsächlich spielbaren Stand. Weiterhin offen bleiben unter anderem Spielerhandel, gemeinsame Expeditionen, zusätzliche Arbeiterberufe, eine physische Förderbandlogistik, Rettungs-Questketten, Sprengstoff/Fossilien, individuelle Bossrätsel und sichtbare Ausrüstungsmodelle am Spieler. Diese Punkte des großen Gesamtkonzepts werden nicht als bereits fertig ausgewiesen.
