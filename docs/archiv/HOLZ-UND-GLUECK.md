# Holzfäller und Glück-Upgrades

## Glück: 1,0× → 1,1× → 1,2× … → 2,0×

Die Werkbank hat ein eigenes **Erzglück-Upgrade** mit zehn Stufen. Jede Stufe erhöht die Chance, den gewürfelten Ertrag zu verdoppeln, um zehn Prozentpunkte:

| Stufe | Anzeige | Doppelbeute-Chance |
|---|---|---|
| 0 | 1,0× | 0 % |
| 1 | 1,1× | 10 % |
| 2 | 1,2× | 20 % |
| 5 | 1,5× | 50 % |
| 10 | 2,0× | 100 % |

Der Multiplikator bezeichnet den durchschnittlichen zusätzlichen Ertrag über viele Abbauvorgänge. Es entstehen ganze Ressourcen, keine unsichtbaren Bruchteile. Bestehende Modul- und Ausrüstungsboni werden zuerst ausgewertet: Hat beispielsweise das Ertragsmodul zwei Erze gewürfelt und schlägt das Glück ebenfalls an, erhält man vier. Der vorhandene Aderbohrer kann anschließend ein weiteres Erz geben. Die Rucksackgrenze bleibt verbindlich; nahe der Grenze können überschüssige Bonuserze nicht aufgenommen werden.

Kosten der nächsten Erzglück-Stufe: **500 × (aktuelle Stufe +1)² $**. Anzeigen an Werkbank und Bohrer zeigen Multiplikator und tatsächliche Doppelchance. Mehrfachbeute erhält grüne Partikel und eine kurze Bonusanzeige.

Holz hat separat dieselbe **1,0× bis 2,0×**-Abstufung. Holzglück kostet **400 × (aktuelle Stufe +1)² $** und verdoppelt die komplette Baumbeute.

## Holzfällerbereich in der Welt

Vom Dorf nach Osten dem Kiesweg folgen. Der neue Bereich enthält ein Sägewerk mit Spitzdach, Werkstation, Holzlager, Baumhaine, Lampen und Holzstapel. Er ist eine Erweiterung der vorhandenen Welt. Bestehende Minen und Dorfstationen bleiben erhalten.

Vier Bäume jeder Art stehen bereit:

| Baumart | Beute je Baum | Nachwachsen | Freischaltung |
|---|---|---|---|
| Eiche | 6 Holz, bei Glück 12 | 45 Sekunden | Sofort |
| Birke | 8 Holz, bei Glück 16 | 60 Sekunden | Axt 2, insgesamt 64 gefälltes Holz, 1.000 $ |
| Fichte | 10 Holz, bei Glück 20 | 75 Sekunden | Axt 5, insgesamt 256 gefälltes Holz, 4.000 $ |

Mit der **Forstaxt Linksklick am Stamm halten**. Sobald der Stamm abgebaut ist, wird der ganze registrierte Baum gefällt. Ein Stumpf bleibt stehen; Stamm und Krone wachsen später wieder. Die Holzbeute liegt im eigenen gespeicherten Holzlager. Nur die dafür vorgesehenen Bäume sind abbaubar, keine Häuser oder dekorativen Holzstapel.

Die Axt gehört zum Spielwerkzeug und erscheint bei Anmeldung beziehungsweise Werkzeugaktualisierung, sofern ein Inventarplatz frei ist. Sie verwendet die normale Minecraft-Axtdarstellung. Das bestehende Ressourcenpaket bleibt unverändert. Vier Plätze werden jetzt für Bohrer, Waffe, Handbuch und Axt benötigt; Lebenssplitter brauchen gegebenenfalls einen weiteren.

Das Holzlager beginnt mit 400 Einheiten. Holz und Bretter teilen die Kapazität. Vor dem Fällen muss Platz für die größtmögliche Doppelernte des gewählten Baums vorhanden sein. Pro Baum gibt es unabhängig davon 4 % Chance auf ein seltenes Harz. Für die Axt ab Stufe 6 wird je Upgrade zusätzlich ein Harz benötigt.

## Sägewerk und eigene Fortschritte

Rechtsklick auf das Sägewerkpult, die Säge oder das Fass öffnet die Verwaltung. Zugang auch über **`/df forestry`**, Handbuch oder Werkbank.

- **Axt:** zehn Verbesserungen; Abbaumultiplikator 2,0 +0,65 je Stufe. Kosten 250 × (Stufe +1)² $.
- **Holzglück:** zehn Verbesserungen mit sichtbarem Multiplikator und Doppelernte-Chance.
- **Holzlager:** zehn Verbesserungen um jeweils 200 Einheiten. Kosten 250 × (Stufe +1)² $.
- **Sägewerk:** drei Verbesserungen. Anfangs zwei Bretter je Holz, danach drei, vier und fünf. Kosten 800 × (Stufe +1)² $.
- **Sägen:** pro Klick bis zu 16 Holz der gewählten Art; ein Brennstoff je Holz. Fehlender Brennstoff oder Platz wird berücksichtigt, ohne Holz zu verlieren.
- **Verkohlen:** zehn Holz werden zu 20 Brennstoff für Schmelze oder Sägewerk. Verbraucht zuerst Eiche, dann Birke und Fichte.
- **Holzaufträge:** fortlaufende Lieferungen von 24/32/40/48 Holz einer freigeschalteten Art. Sie zahlen 150 % des normalen Stammwertes, jeder fünfte Auftrag zusätzlich ein Harz. Ein veralteter Menüklick kann keinen bereits erledigten Auftrag erneut abrechnen.

Verkaufspreise je Eiche/Birke/Fichte: Holz **6/10/16 $**, Bretter **4/7/11 $**. „Alles Holz & Bretter verkaufen“ verkauft ausschließlich diese Forstmaterialien und lässt Erze, Barren und Harz unberührt. Der Holzfällerrang steigt alle 128 gesammelten Holz und zeigt den persönlichen Sammelfortschritt; Freischaltungen hängen an den ausgewiesenen Axt-/Sammelvoraussetzungen.

## Speicherung und Prüfgrenzen

Glück-Stufen, Holz, Bretter, Harz, Upgrades, Aufträge und Zähler werden mit dem bestehenden Spielerprofil gespeichert. Alte Spielstände starten bei Glück 1,0× und erhalten keine automatische Umverteilung vorhandener Ressourcen. Die Welt wird in kleinen Bauabschnitten erweitert; ein eigener Marker verhindert vollständigen Neuaufbau bei jedem Start.

Dieses Update bringt aktives Holzfällen und Verarbeitung. Es fügt keinen automatischen Holzarbeiter hinzu; die vorhandene Offline-Produktion der Bergarbeiter bleibt bestehen. Nach einem Serverneustart werden registrierte Forstbäume wiederhergestellt. Während des normalen Betriebs laufen Baumwartezeiten weiter und fällige Bäume werden beim Laden ihres Weltabschnitts wieder aufgebaut.

Tests prüfen die mathematischen Ertragserwartungen aller Glückstufen, Preise und Höchststufen, Ressourcenverbrauch, Kapazitäten, doppelte Auftragsklicks, Freischaltungen, SQLite-Neustart sowie alle Baum- und Sägewerkswege. Die native Serverdiagnose `df verify-forest` prüft die gebauten Blöcke und die Wiederherstellung eines Baums, ohne Spielerbeute zu erzeugen. Ein tatsächlich gespielter Abbau mit Minecraft-Client steht noch aus.
