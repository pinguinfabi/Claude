# Party-Dungeons und schneller Nahkampf

**Erweitert:** Jeder Sieg erhöht jetzt das persönliche Dungeonlevel. Abhängig davon gibt es 5–8 Wellen, Elitegegner, Rissjäger, wechselnde Bedingungen und stärkere Beute. Gruppen nutzen das höchste Mitgliedslevel plus Gruppenskalierung. Lebenssplitter ermöglichen Heilung im Bosskampf. Aktuelle Regeln: [DUNGEON-PROGRESSION.md](DUNGEON-PROGRESSION.md). Die fünf Wellen und Beutechancen unten beschreiben den Einstieg auf Level 1.

## Im Spiel starten

**Weltintegration:** Rechtsklick auf das Startpult im neuen Portalhaus hinter dem Markt öffnet das gestaltete Menü. Drei verbundene Hallen, Tore und Runenschreine sind inzwischen implementiert. Überlebende bleiben nach Wellen an ihrer Position und erhalten 15 % Leben zurück; Wiederbelebung erfolgt mit 50 % Leben. Details: [DUNGEON-WELT.md](DUNGEON-WELT.md).

`/df dungeon` öffnet das Gewölbemenü. Es ist auch im Handbuch erreichbar. Solo einfach eine Schwierigkeit anklicken. Eine bestehende Party muss vor jedem Lauf ihre Bereitschaft bestätigen.

1. Leiter: `/df party create` und `/df party invite Spielername`.
2. Eingeladener Spieler: `/df party accept` innerhalb von 60 Sekunden.
3. Alle Mitglieder: `/df party ready` oder Bereitschaft im Dungeonmenü anklicken.
4. Leiter: Im Menü Gebiet und Normal, Veteran oder Albtraum auswählen.

Maximal vier Mitglieder. Alle müssen das Gebiet freigeschaltet haben und im Überlebensmodus sein. Veteran setzt einen Normal-Sieg desselben Gebiets voraus, Albtraum einen Veteran-Sieg – für jedes Mitglied. Mit `/df dungeon start 1 1` lässt sich Normal, Gebiet 1 direkt starten. `/df party` zeigt den Gruppenstatus.

## Der Lauf

Drei verbundene Hallen aus echten Minecraft-Blöcken entstehen außerhalb der Privatminen. Vier getrennte Instanzen können gleichzeitig laufen. Pfeiler, Deckenbögen, hängende Laternen, Runenwände und gebietsabhängige Materialien gliedern die Räume. Nach den Rätseln öffnen sich Tore für den Weg zur nächsten Halle. Der Bau wird über mehrere Serverticks verteilt.

- Fünf Monsterwellen mit auf die Startgruppe skalierten Gegnerzahlen und Lebenspunkten.
- Sprenger markieren eine rote Fläche am Ziel; Strahlenwirker kündigen einen gerichteten Strahl an; Heilrufer regenerieren nahe Verbündete. Kontaktangriffe halten die Gruppe in Bewegung.
- Nach Welle 2: Drei angezeigte Farben merken und anschließend die entsprechenden Blöcke an der Nordwand mit Linksklick in Reihenfolge aktivieren. Fehler verursachen Schaden und zeigen die Folge erneut. `/df dungeon hint` wiederholt sie ohne Schaden; die bisherige Eingabe beginnt von vorn.
- Nach Welle 4: Gleichzeitig drei Sekunden auf den markierten Bodenplatten stehen. Solo ist die linke Platte nötig, zu zweit die linken beiden, ab drei aktiven Spielern alle drei. Ein Spieler kann nicht mehrere Siegel ersetzen.
- Welle 5: Runenwächter und Begleiter. Der Boss kombiniert Flächenangriff, Strahl und Heilung für seine Begleiter. Unter halbem Leben werden seine Warn- und Erholungszeiten kürzer.
- Rechtsklick-Fähigkeiten, Rüstung, kritische Treffer, Dolch-Rückenangriffe, Parade, Ausweichen und Schadenszahlen funktionieren auch im Dungeon.

Der Lauf endet nach 30 Minuten. Wer besiegt wird, wartet geschützt hinter der Arena und kehrt nach der geschafften Phase zurück. Sind alle verbleibenden Mitglieder besiegt, ist der Lauf verloren. Abmelden reserviert den Platz für 60 Sekunden. Danach endet die Teilnahme. Laufende Gruppen nehmen keine zusätzlichen Mitglieder auf.

`/df dungeon leave`, `/df home` oder das Verlassen von Deepforge beendet die eigene Teilnahme ohne Abschlussbeute. Bei einem Neustart wird ein laufender Dungeon beendet. Ausrüstung wird dadurch nicht gelöscht. Reguläre Erz-, Boss- und Wirtschaftsfortschritte bleiben erhalten.

## Persönliche Beute

Jedes verbliebene Mitglied erhält dieselbe Geldprämie, aber einen eigenen Ausrüstungswurf. Die Gruppengröße teilt die Prämie nicht auf.

| Schwierigkeit | Geld Gebiet 1 | Selten | Episch | Legendär | Mythisch |
|---|---:|---:|---:|---:|---:|
| Normal | 600 $ | 70 % | 24,5 % | 5 % | 0,5 % |
| Veteran | 1.200 $ | 60 % | 31 % | 8 % | 1 % |
| Albtraum | 1.800 $ | 50 % | 37,5 % | 11 % | 1,5 % |

Pro Gebiet steigt die Grundprämie um 450 $, multipliziert mit der Schwierigkeit. Dazu kommen Staub, Monsterteile und Forschungsnotizen. Ein voller Beutebeutel wandelt ausschließlich das neue Teil in Staub um. Bestehende Gegenstände bleiben erhalten.

Geld, Gegenstände, Siege, persönliche Bestzeit und Laufbeleg werden für die gesamte Gruppe in einer SQLite-Transaktion gespeichert. Derselbe abgeschlossene Lauf zahlt nicht erneut. Dungeon-Siege ersetzen keine Freischaltungen der normalen Minenbosse.

## Weitere Änderungen

- Nahkampf hat keine Waffenwartezeit mehr. Pro echtem Servertick wird höchstens ein Nahkampfklick angenommen. Trefferschaden: Basiswert × 0,65 × Tempowert / 1,6. Tempoausrüstung verbessert dadurch den Schaden. Fähigkeiten behalten eigene Ausdauerkosten und Abklingzeiten.
- Normale Minenmonster erhalten doppelte, Minenbosse 1,6-fache bisherige Lebenspunkte. Haltungsschaden sinkt auf 45 %. Rückstoß wird unabhängig vom Trefferschaden begrenzt. Tooltips nennen tatsächlichen Trefferschaden und Beispiel-DPS bei vier Klicks pro Sekunde.
- Die sieben Bossgebiete unterscheiden sich zusätzlich in Körperbreite, Höhe und Armlänge.
- Waffen stehen in der ersten Person leicht schräg und weiter außen. In der dritten Person liegt der Griff etwas vor dem Arm. Beide Hände wurden im Ressourcenpaket berücksichtigt; die Abnahme im NoRisk-Client steht noch aus.
- Arbeiter halten die Chunks entlang ihrer Wege während der Online-Schicht geladen. Der Diagnoselauf nutzt dieselben Routentickets wie echte Arbeiter statt einer gesonderten großflächigen Zwangsladung. Abmelden und Neustart geben die Tickets frei. Produktion bleibt in der bestehenden, zeitbasierten Abrechnung; NPC-Animationen erzeugen keine zweite Belohnung.

## Stand und nächste Ausbaustufen

Implementiert ist ein wiederholbarer Gewölbetyp mit sieben Materialthemen, drei Schwierigkeitsgraden, zwei Rätselarten und Gruppenfortschritt. Nicht enthalten sind verzweigte Dungeonräume, zufällige Raumkombinationen, Handel zwischen Spielern, Gilden, weitere Arbeiterberufe und ein serverweites Bestzeiten-Ranking. Die persönliche Bestzeit ist gespeichert. Vollständige Mehrspieler- und langfristige Balancetests stehen aus.

Konsole: `df verify-dungeon` baut eine Testinstanz und prüft Modell- und Chunkbereinigung; `df dungeon-status` liefert das Ergebnis. Dabei werden keine Spielerstände verändert oder Belohnungen vergeben.
