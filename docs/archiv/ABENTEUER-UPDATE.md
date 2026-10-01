# Abenteuer-Update: Lernen, Builds, Nebenräume und Sammelziele

Dieses Update ergänzt die vorhandene Wirtschaft, Arbeiter, Minen und drei verbundenen Dungeonhallen. Es setzt keinen Spielstand zurück. Alle Inhalte sind in der Minecraft-Welt und über die vorhandenen texturierten Menüs erreichbar. Bestehende Modelle werden weiterverwendet; ein neues Ressourcenpaket ist dafür nicht nötig.

## 1. Spielbarer Einstieg

Vorarbeiter **Jorin** steht am Dorfplatz. Rechtsklick oder `/df tutorial` öffnet zwölf Lernschritte. Oben steht immer ein aktuelles Lernziel; ein zuschaltbarer Partikelwegweiser zeigt 30 Sekunden lang die Richtung zur Station beziehungsweise zum nächsten vorhandenen Erz.

1. 15 Erze abbauen.
2. Zehn Erze einlagern.
3. Erste Schmelze bauen.
4. Manuell einen Barren schmelzen.
5. Einen Barren verkaufen.
6. Bohrer verbessern.
7. Ausweichschritt üben: Waffe, schleichen, rechtsklicken.
8. Bei fehlendem Leben einen Lebenssplitter verwenden.
9. Ersten Minenboss besiegen.
10. Ersten Arbeiter einstellen.
11. Runenrätsel im Dungeon lösen.
12. Dungeon abschließen.

Die beiden ersten Lernprämien betragen je 650 $, damit Startgeld und Prämien die erste Schmelze finanzieren. Die fertige Schmelze bringt zehn Brennstoff; nach dem Ausweichen gibt es einen Lebenssplitter. Weitere Schritte bringen jeweils 100 $, der erste Boss 1.000 $. Bereits erfüllte Voraussetzungen werden erkannt. Neue Aktionszähler beginnen bei bestehenden Spielständen mit null; die alten Käufe und Bosssiege bleiben erhalten.

Das Tutorial lässt sich pausieren und später fortsetzen. Einzelne Schritte können ohne Prämie übersprungen werden. Bereits abgeschlossene oder übersprungene Schritte lassen sich nicht erneut belohnen. Hinweise bleiben im Menü lesbar.

## 2. Ausrüstung mit echten Effekten

| Artefakt | Effekt | Fundgebiete |
|---|---|---|
| Donnerklinge | Jeder achte gewertete Treffer löst Kettenblitze zu bis zu drei weiteren Gegnern in sechs Blöcken Reichweite mit Sichtlinie aus. | 1 und 5 |
| Blutstahl | Besiegte Gegner hinterlassen eine persönliche Heilkugel: 4 LP, acht Sekunden Lebensdauer. | 2 und 6 |
| Runenhammer | Jeder sechste gewertete Treffer macht das Ziel vier Sekunden verwundbar. Bei normalen Gegnern und Dungeon-Gegnern +15 % Schaden; der geschlossene Minenboss-Panzer lässt 85 statt 55 % Schaden durch. | 3 und 7 |
| Aderbohrer | Zusammenhängende Erzadern haben zusätzlich 25 % Chance auf ein weiteres Erz. Dazu Bergbaumodul-Werte für Tempo und Ertrag. | 4 |

Der normale Schlag bleibt ohne Aufladebalken. Nur Effektladungen zählen höchstens alle vier Serverticks; Blitze haben zwei Sekunden Effektpause, Panzerbruch sechs Sekunden. Sekundäre Blitztreffer laden keine weiteren Blitze auf. Heilkugeln können nur vom berechtigten Spieler aufgesammelt werden, maximal sechs liegen gleichzeitig bereit. Kein Wiederbeleben durch Heilkugeln.

Jedes der drei Sets besitzt Helm, Brustschutz, Beinschutz und Stiefel:

| Set | Zwei Teile | Vier Teile |
|---|---|---|
| Sturmrufer | Donnerklinge lädt nach sechs statt acht Treffern. | Zusätzlich +25 % Kettenblitzschaden. |
| Blutwächter | Heilkugeln heilen 6 statt 4 LP. | Heilkugeln entstehen auch ohne Blutstahl-Waffe. |
| Tiefenschürfer | +10 Prozentpunkte Extra-Erz-Chance. | Zusätzlich +15 Prozentpunkte Abbaubonus. |

Die vorhandenen Werteobergrenzen gelten weiterhin. Effekte stehen in der Beutebeschreibung und im Tooltip der gehaltenen Waffe beziehungsweise des Bohrers. Setfortschritt wird ebenfalls angezeigt. Ausrüsten erfolgt wie bisher im Beutemenü `/df loot`.

## 3. Freiwillige Dungeon-Abzweigungen

Alle drei Hallen haben links eine gebaute Seitenkammer mit echtem Gang und Tor. Die Hauptroute und Rätsel bleiben bestehen; Überlebende laufen weiterhin zwischen den Hallen.

- **Halle 1:** Nach dem Runenrätsel kann die Gruppe weitergehen oder eine Prüfung wählen. Der Gruppenleiter aktiviert den roten Elitealtar für einen Bonusfund oder den violetten Fluchaltar für zwei. Es erscheinen Gruppengröße +2 Elitegegner. Normalprüfung: 140 % der jeweiligen Basis-LP; Fluchprüfung: 200 %. Die Haupttore schließen bis zum Sieg. Nur eine Prüfung pro Lauf; alle lebenden Mitglieder müssen beim Start noch in dieser Halle sein.
- **Halle 2:** Im verstaubten Fass liegt ein Schlüssel für die ganze Gruppe. Nach dem Siegelrätsel öffnet die Seitenkammer: Zellenschloss rechtsklicken, Bergarbeiter befreien. Ein zusätzlicher Bonusfund und ein dauerhafter Händlerrabatt warten beim erfolgreichen Abschluss.
- **Halle 3:** Mit dem gefundenen Schlüssel den Schlossblock neben dem linken Tor rechtsklicken, dann die Truhe in der Schatzkammer sichern. Ein weiterer Bonusfund. Der Endkampf läuft dabei weiter.

Die normale Route bleibt ohne Nebenaufgaben spielbar. Optionaler Fortschritt gehört zum aktuellen Lauf. **Ausgezahlt wird erst nach dem Endboss**, gemeinsam mit der normalen Dungeonbelohnung und dem Levelaufstieg. Bei Abbruch oder Niederlage gibt es keine Bonusauszahlung. Ein gespeichert abgeschlossenes Gewölbe lässt sich nicht nochmals abrechnen.

Pro Abschluss kommt ein zusätzlicher Set-/Artefaktfund hinzu: 4 % Gebietsartefakt, sonst Setrüstung. Jeder Nebenaufgaben-Bonusfund hat 20 % Artefaktchance. Dazu je Bonusfund 250 $ +100 $ pro Gebietsindex, acht Staub und zwei Forschungsnotizen. Fluchprüfung zählt als zwei Bonusfunde. Alle neuen Dungeonfunde tragen das Lauflevel; offensive und defensive Werte skalieren damit. Bergbau-Nutzeffekte werden nicht unbegrenzt hochskaliert.

## 4. Sichtbare Langzeitziele

`/df journal` oder das Abenteuerbuch im Handbuch zeigt vier Artefakte, Fundorte, Effekte, gesammelte Materialien und drei Sets mit entdeckten/ausgerüsteten Teilen. Gefundene Artefakte bleiben als entdeckt registriert, auch wenn sie später verkauft oder zerlegt werden. Ein voller Beutebeutel wandelt neue Funde in Staub um und registriert die Entdeckung.

Jedes Artefakt kann gezielt hergestellt werden: **40 Bossfragmente und 30 Monsterteile seines ersten Fundgebiets**, dazu 2.000 / 4.000 / 6.000 / 8.000 $. Voraussetzung ist der entsprechende Minenboss oder ein normaler Dungeonabschluss in diesem Gebiet. Jeder Dungeonabschluss gibt jetzt zusätzlich zwei Gebiets-Bossfragmente. Damit gibt es ein festes Sammelziel als Alternative zum Glücksfund. Herstellung ist außerhalb von Kämpfen möglich; ein voller Beutel verbraucht keine Zutaten.

Im Dorf zeigen sieben Sockel die erkämpften Boss-Trophäen. Die Werkstatt bekommt mit jedem fünften Bohrerlevel einen neuen sichtbaren Rang und bis zu vier ausgestellte Bohrermodelle.

**Relikthändlerin Mira** erscheint nach dem ersten Minenboss oder einem Dungeonabschluss. Sie verkauft einen Lebenssplitter für 250 $ beziehungsweise fünf Schmiedestaub für 750 $. Nach der ersten erfolgreich abgeschlossenen Bergarbeiterrettung kosten diese Angebote dauerhaft 20 % weniger. Zugang auch über `/df merchant`.

## Technik und Grenzen

- Fortschritt und Ausrüstung bleiben in der bestehenden SQLite-Datenbank. Gruppenbelohnungen inklusive Nebenaufgaben werden in einer gemeinsamen Transaktion gespeichert; Fehler rollen sämtliche betroffenen Auszahlungen zurück.
- Dungeons behalten Gruppen-/Levelskalierung, hohe Boss-LP, Rückenkonter, Rätsel, Segen und bisherige Heilung. Aktive Läufe enden bei Neustart ohne Verlust vorhandener Ausrüstung.
- Diagnose: Serverkonsole `df verify-dungeon` / `df dungeon-status`; Dorfprüfung `df verify-adventure` bei geladenen Dorfchunks. Diagnosen schenken echten Spielern keine Beute.
- Nebenräume sind drei feste, spielbare Varianten. Zufällig zusammengesetzte Raum-Pools, weitere Artefaktfamilien und zusätzliche NPC-Spielermodelle sind nicht Bestandteil dieses Updates. Vorarbeiter, Händlerin und Gefangener verwenden Villager; bestehende Bergarbeiter verwenden weiterhin Citizens-Spielermodelle.
- Automatisierte Tests und native Paper-Diagnose ersetzen keinen gespielten Multiplayer- oder langfristigen Balancetest. Die neue Geometrievorschau ist aus Bauplandaten gerendert, keine Minecraft-Spielaufnahme.
