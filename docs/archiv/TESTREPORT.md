# Deepforge 0.1.0 – Prüfbericht

## Ausgeführt

- Kompilierung gegen Paper API 1.21.8 mit Java 21.
- Maven-Paketierung einschließlich SQLite JDBC und Gson.
- 144 automatisierte Tests bestanden; 0 fehlgeschlagen.
- de.deepforge.game.AdventureTest: 10 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.BoardViewTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.BossPressureTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.BossRulesTest: 7 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.DungeonBlessingsTest: 2 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.DungeonRulesTest: 10 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.EconomyTest: 8 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.EquipmentLoreTest: 4 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.ForestryTest: 7 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.GearTest: 11 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.HealingTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.HitFeedbackTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.IndustryTest: 9 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.JoinFlowTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.MonsterHealthTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.PartyBookTest: 4 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.ProductionTest: 13 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.RapidCombatTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.game.WeaponRulesTest: 5 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.storage.ProfilesTest: 12 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.world.CampBlueprintTest: 6 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.world.DungeonLayoutTest: 4 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.world.ForestBlueprintTest: 3 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.world.MineBlueprintTest: 7 Tests, 0 Fehler, 0 Ausnahmen
- de.deepforge.world.WorkerRoutesTest: 1 Tests, 0 Fehler, 0 Ausnahmen
- Ressourcenpaket: 235 JSON-Dateien, 68 PNG-Dateien, 1.150 Notenblockzustände, davon 7 eigene Erzmodelle.
- Referenzen der eigenen Texturen/Modelle, JSON-Format, PNG-Header, Modellgrenzen und ZIP-Integrität geprüft.
- GUI-Textur als Bild geprüft. Java-Code formatiert.
- JAR-Struktur, ZIP-Prüfsummen und fertige Release-Dateien geprüft.

## Lokaler Server geprüft

- Paper 1.21.8 Build 60 startet mit Citizens Build 3887 und aktiviertem Deepforge.
- Minecraft-Statusabfrage auf 127.0.0.1:25565 erfolgreich.
- Ressourcenpaket über lokalen HTTP-Server geladen und SHA-1 geprüft.
- Aktueller Serverstart ohne ERROR-Einträge.

## Frühere Dorf-Migration geprüft

- Layout 2 mit 501.414 geplanten Blockpositionen und 117 von Paper validierten Blockzuständen.
- Sechs zusätzliche Bauplanprüfungen: Stationen, Eingänge und Arbeiterziele erreichbar; Spawn frei; Grundstücksgrenzen eingehalten; Untergrund unberührt; Blätter dauerhaft.
- Migration des bestehenden Grundstücks 0 auf dem laufenden Paper-Server abgeschlossen.
- 33 tatsächliche Serverblöcke geprüft, einschließlich aller Stationen und aller sieben Minenräume.
- 1 gespeicherter Spielerstand bytegleich zum Datenbankeintrag vor dem Umbau.
- Sicherung von Welt, Plugin-Daten, vorherigem Plugin und Ressourcenpaket vor dem Umbau angelegt.
- Schriftanbieter-Reihenfolge und reduzierte Werkzeuggröße im Pack geprüft.
- Geometrie des Bauplans als vereinfachte 3D-Vorschau visuell geprüft.

## Frühere Minen-Migration geprüft

- Sieben neue Höhlennetze statt der alten Kastenräume; 1.254.792 Blockpositionen einschließlich Felshülle.
- Sieben zusätzliche Bauplanprüfungen über sämtliche Ebenen: alle Erzadern erreichbar, Haupt- und Nebenwege verbunden, Galerie zugänglich, Spawns frei, Hülle geschlossen, Kammerbreiten/Decken variabel, Gebietsmotive vorhanden.
- 3162 registrierte Erzblöcke über die sieben Gebiete; Abbau, Scanner und Regeneration auf diese Positionen umgestellt.
- Blockzustände aller sieben Gebiete durch Paper validiert; Migration auf dem lokalen Server abgeschlossen.
- 177 tatsächliche Serverblöcke geprüft: Erzstichproben, Aufzüge, Bossaltäre, Spawns, Galerien, Felshülle, trockene Routen und erhaltene Dorfstationen.
- Spielerstand unverändert gegenüber der Sicherung vor diesem Umbau; Dorfoberfläche nicht überschrieben.
- Statusabfrage und Ressourcenpaketdownload erfolgreich, aktueller Start ohne ERROR-Einträge.
- Grundrisse und vereinfachte Perspektivansichten des Bauplans visuell geprüft.

## Vorherige Kampf- und Beuteerweiterung geprüft

- 21 zusätzliche Tests für Beute, Seltenheitsgrenzen, Pechschutz, eindeutige Kampfbelohnungen, Herstellung, geschützte Ausrüstung, Werteobergrenzen, getrennte Ringplätze, Angriffszonen und Schwierigkeitsfreischaltung.
- SQLite-Neustart mit Ausrüstung/Favoriten/Kampfbeleg sowie echte Migration einer Schema-1-Datenbank geprüft. Doppelte Item-IDs und ungültige Referenzen werden abgewiesen.
- 28 Modellvarianten mit 196 ItemDisplay-Körperteilen in 112 Posen auf dem lokalen Paper-Server erzeugt, animiert und entfernt.
- Alle 6 Warnflächen auf dem Server aufgerufen; keine zurückgebliebenen Testentitäten.
- Neues JAR und Ressourcenpaket installiert; Dateien mit Build-Ausgabe verglichen. Pack-Download und SHA-1 geprüft.
- 1 bestehender Spielerstand nach Update und Diagnose bytegleich zum Backup; kein Testgeld oder Testloot vergeben.
- Sieben zusammengesetzte Modelle als vereinfachte Geometrievorschau visuell geprüft; Blickrichtung, Bodenkontakt und Armanimation im Code korrigiert.
- Aktueller Serverstart und Diagnose ohne ERROR-Einträge. Kein vollständiger Bosskampf mit einem echten Minecraft-Client durchgeführt.

## Vorherige Textur- und Schienenkorrekturen geprüft

- Fehlerursache der fehlenden Texturen mit den Atlasquellen des installierten Minecraft-1.21.8-Clients abgeglichen. Alle eigenen Modelltexturen befinden sich nun in geladenen Block-/Item-Verzeichnissen.
- 28 Handtransformationen geprüft: sieben Werkzeuge/Waffen, beide Hände, erste und dritte Person. Griffposition nach Skalierung und Rotation rechnerisch am Handpunkt.
- RAILS OK: 3/3 mobs physically crossed 3 rail strips; ticks=50. Native Wegfindung und tatsächliche Bewegung auf Paper geprüft; Testblöcke anschließend wiederhergestellt. Der Test hält seine Chunks und Testmonster auch ohne anwesenden Spieler aktiv.
- Erster Diagnoseversuch konnte mangels aktiver Physik keinen Bodenweg berechnen; Testinitialisierung korrigiert und anschließend erfolgreich ausgeführt.
- Fünf neue Tests für Dolch-Rückenangriffe, gerichtete Panzerabwehr und wiederholbare Jagdaufträge; Neustarttest um Jagdfortschritt und Belohnungen erweitert.
- 1 vorhandener Spielerstand nach Deployment und Diagnose bytegleich zum aktuellen Backup. Neues JAR und Pack bytegleich zur Build-Ausgabe.
- Aktueller Serverstart und abschließende Diagnose ohne ERROR-Einträge; Ressourcenpaketdownload mit aktuellem SHA-1 geprüft.
- Bildschirmdarstellung der neuen Handpositionen im verwendeten NoRisk-Client noch nicht visuell abgenommen.

## Vorheriges Treffer- und Item-Update geprüft

- Sieben zusätzliche Java-Tests zu Rückstoß, effektiver Schadensanzeige und tatsächlichen Tooltipwerten.
- RAILS OK: 3/3 mobs physically crossed 3 rail strips; ticks=40; RECOIL OK: 3/3 native impulses, boss impulse and wall collision.
- DEEPFORGE COMBAT OK: 28 rigs, 196 bones, 112 poses including hit flashes, 4 damage labels, 6 telegraphs; zero leaked entities; active=0.
- 35 Treffer-Modellvarianten und 28 Handtransformationen validiert. Automatische Linkshandspiegelung und zusätzliche Third-Person-Drehung mit dem installierten 1.21.8-Clientcode abgeglichen.
- Egoansichten rechnerisch auf sichtbare Geometrie und freien Bereich um das Fadenkreuz geprüft; Geometrieprojektion visuell geprüft. Keine visuelle Abnahme im NoRisk-Client.
- 1 gespeicherter Spielerstand bytegleich zum Backup direkt vor diesem Update; Dateien identisch zum Build. SHA-1: d304f4a39ec7465a5faeb875eab9c8b1944662e4.
- Lokaler Server läuft mit neuem Plugin und Pack, aktueller Start und Diagnose ohne ERROR-Einträge.

## Aktueller Arbeiter- und Industrieausbau geprüft

- Elf zusätzliche Java-Tests: Wege zu Erzadern in sieben Gebieten, erreichbare Fundstellen, Forschungswirkung, Auftragsverbrauch und Doppelzahlungsschutz, gesperrte Funde, Sammlungsmigration, Schichtpausen, Online-/Offline-Gleichheit und SQLite-Neustart.
- WORKERS OK: Citizens player walked village -> lift -> real ore, performed 12 swings and returned to mine depot; ticks=1905.
- EXPEDITIONS OK: 21 reachable caches, 63 model/label/interaction entities created and removed; no rewards issued.
- Erste NPC-Diagnose zeigte einen Zielabstandskonflikt; Wegsuche auf Citizens mit exakten Zielblöcken umgestellt. Ein weiterer Durchlauf zeigte unnötige Wiederholungswartezeiten zwischen Wegpunkten; beim Wechsel zum nächsten Punkt entfernt. Kompletten Arbeitszyklus erneut getestet.
- Fund-Entity-Diagnose lädt ihre Chunks vor dem Spawn und stellt anschließend vorherige Ladezustände wieder her.
- 1 gespeicherter Spielerstand bytegleich zum Backup direkt vor diesem Ausbau; Diagnose vergibt weder Geld noch Beute. Vorhandene Welt erhalten.
- Aktueller Paper-Start und abschließende Diagnose ohne ERROR-Einträge; JAR identisch zum Build. Bestehendes Ressourcenpaket weiterverwendet und Download geprüft.
- Neue Menüs und NPC-Arbeitsanimationen noch nicht visuell im NoRisk-Client abgenommen.

## Vorheriger Party-Ausbau geprüft

- Party-Einladungen, Ablaufzeiten, Gruppenlimit, Bereitschaft, Leiterwechsel, Lootgrenzen und persönliche Bestzeiten automatisiert geprüft.
- SQLite-Gruppenbelohnungen über Neustarts geprüft; absichtlich ausgelöster Fehler beim zweiten Mitglied rollt auch die erste Auszahlung zurück und lässt gecachte Originalprofile unverändert.
- Tatsächlicher Schaden im Tooltip mit dem schnellen Kampfsystem abgeglichen. Tempoausrüstung bleibt wirksam; Gegnerleben und Haltungsschaden angepasst.
- Lokaler Dungeon-Laufzeittest: OK: arena, runes, two model rigs, cleanup, chunk tickets.
- Arbeiterprüfung ohne gesonderte großflächige Zwangsladung: WORKERS OK: Citizens player walked village -> lift -> real ore, performed 12 swings and returned to mine depot; ticks=1905.
- Aktuelle Modellprüfung: DEEPFORGE COMBAT OK: 28 rigs, 196 bones, 112 poses including hit flashes, 4 damage labels, 6 telegraphs; zero leaked entities; active=0.
- 1 vorhandener Spielerstand bytegleich zum Backup vor diesem Update; weder Testgeld noch Testloot vergeben.
- Ressourcenpaket für beide Handansichten neu gebaut und geometrisch validiert. Serverdateien stimmen mit Build überein; aktuelles Serverlog ohne ERROR-Einträge.
- Kein vollständiger Dungeon mit echten Mehrspieler-Clients oder visueller NoRisk-Abnahme getestet.

## Dungeonprogression und Heilung geprüft

- Zehn zusätzliche Tests: Migration vorhandener Siege, genau ein Aufstieg pro Abschluss, höchstes Gruppenlevel, begrenzte Spawnzahlen, skalierende Belohnungen, neue Gegnerarten und Kampfbedingungen, Heilvorrat, Heilungsgrenzen, Abklingzeit und SQLite-Neustart.
- Fehlgeschlagene Gruppenbelohnung rollt weiterhin alle Mitglieder zurück; Tests prüfen jetzt zusätzlich unverändertes Level und unveränderten Heilvorrat.
- Laufzeitprüfung auf Paper: OK: level 31, party 4, 8 waves, 150 enemies, 4 kinds, elites, boss, queued spawns, runes, healing item, cleanup, chunk tickets.
- Der Laufzeittest simuliert die Viererskalierung ohne echte Spieler und entfernt seine Gegner automatisch. Er ist kein gespielter Mehrspieler-Dungeon.
- 1 bestehender Datenbankeintrag bytegleich zur Sicherung direkt vor diesem Update; keine Testbelohnung vergeben.
- Aktuelles JAR und neues Pack stimmen mit Build überein. Pack-Download und SHA-1 geprüft; Serverlog ohne ERROR-Einträge.
- Neues Lebenssplittermodell mit gültigem Modellschlüssel auf Paper erzeugt und entfernt; Textur-, JSON- und ZIP-Prüfungen bestanden. Visuelle Clientprüfung und langfristiges Balancing stehen aus.

## Bossbalancing und Rückenkonter geprüft

- Fünf zusätzliche Java-Tests für Konterwarnung, weitere Treffer während der Warnung, Konterpause, Trefferposition und -alter, Fluchtgrenze, Standfestigkeit sowie Level-4-Dolchburst und stärkere Gruppenskalierung.
- Die erste Laufzeitprüfung deckte zufällige Vanilla-Hühnerreiter auf: übrig gebliebene Hühner wurden in der Diagnosearena bereinigt, zufällige Spawninitialisierung für eigene Minen- und Dungeon-Gegner deaktiviert und erwachsene Gegner ohne Vanilla-Ausrüstung festgelegt. Diagnose danach vollständig wiederholt.
- Paper-Dungeon-Diagnose mit aktuellen Lebenswerten: OK: level 31, party 4, 8 waves, 150 enemies, 4 kinds, elites, boss, queued spawns, runes, healing item, cleanup, chunk tickets.
- 1 Spielerstand bytegleich zum Backup direkt vor diesem Update. Installiertes JAR identisch zum Build, Ressourcenpaket unverändert, aktuelles Serverlog ohne ERROR-Einträge.
- Die Diagnose entfernt ihre Gegner automatisch. Sie prüft keinen echten Bosskampf und keine gespielten Ausweichmanöver; die neue Konterlogik wurde separat automatisiert geprüft.

## Weltintegrierte Dungeons geprüft

- Sechs neue Java-Tests: Laufwege in sieben Gebietspaletten, geschlossene Tore, Ankunft der Gruppe, isolierte Oberflächenmigration, persönliche Segen und Einmalwahl. Der bestehende Dorf-Wegtest prüft jetzt auch den Gewölbeeingang.
- Native Instanzprüfung: OK: level 31, party 4, 8 waves, 150 enemies, 4 kinds, elites, boss, queued spawns, runes, healing item, 3 connected rooms, walkable gates, cleanup, chunk tickets.
- Tore und ihre Laufkorridore wurden auf Paper geöffnet, auf Boden und Kopffreiheit geprüft und nach Raumwechsel wieder geschlossen. Alle drei Hallen erreicht und alle Testobjekte bereinigt.
- 1 Dorfzugang mit Startpult und Dach im laufenden Server geprüft. 1 Spielerstand identisch zur Sicherung vor diesem Ausbau.
- Geometrievorschau aus den echten Bauplänen gerendert und visuell geprüft. Das Menü verwendet den bereits vorhandenen Texturrahmen und vorhandene Modelle; das Ressourcenpaket bleibt unverändert.
- Kein gespielter Mehrspieler-Lauf und keine visuelle Minecraft-Client-Abnahme des neuen Menüs.

## Abenteuer-Update geprüft

- Tutorialprämien, Überspringen/Pausieren, Abschlussziel, alte Profile ohne neue Felder, Artefaktherstellung ohne Teilabbuchungen, voller Beutel, Setwerte, tatsächliche Itembeschreibungen, Effektladungen und Effektpausen automatisiert geprüft.
- Nebenaufgabenbelohnungen mit Einmalbeleg geprüft; Neustart erhält Tutorialzähler, Artefakte und Gruppenbonus. Ein absichtlich fehlschlagendes zweites Gruppenprofil rollt auch Rettung, Fragmente und Beute des ersten zurück.
- Wegsuche erreicht Nebenräume in allen sieben Paletten; geschlossene Seitentore sperren sie.
- Native Dorfprüfung: OK: 1 guides, 1 merchants, 3 trophies, 4 artifact item models, village stations intact.
- Native Instanzprüfung: OK: level 31, party 4, 8 waves, 156 enemies, 4 kinds, elites, boss, queued spawns, runes, healing item, 3 connected rooms, walkable gates, optional challenge, rescue, key chest, cleanup, chunk tickets.
- Die erste Dorfdiagnose benötigte aktiv geladene Chunks. Der Prüflauf lädt sie nun vorübergehend, stellt die vorherige Forceload-Belegung wieder her und wurde nach Serverneustart vollständig wiederholt. Erste Diagnose protokolliert unter work/runtime/adventure-first-runtime.log.
- 1 Spielerstand bytegleich zur Sicherung vor dem Update. Installiertes JAR entspricht dem Build; unverändertes Pack über HTTP und SHA-1 geprüft. Abschließender Serverlauf ohne ERROR-Einträge.
- Aktualisierte Geometrievorschau zeigt die drei Seitenkammern. Keine echte Clientaufnahme; der automatisierte Dungeonlauf entfernt seine Gegner selbst und ersetzt keinen gespielten Kampf.

## Glück und Holzfäller geprüft

- Elf zusätzliche automatisierte Tests: Erwartungswerte aller Glückstufen einschließlich Kombination mit bestehenden Boni, Upgradepreise und Grenzen, Holzernte/Freischaltung/Kapazität, Sägeverbrauch, geschützte Erze beim Holzverkauf, Einmalaufträge, Harzvoraussetzung, Kohleverarbeitung und SQLite-Neustart.
- Bauplanprüfung: nur eigene Oberflächenerweiterung, keine überlappenden Baumkronen, dauerhafte Blätter, alle zwölf Baumstämme und Sägewerksstationen zu Fuß erreichbar. Bestehende Dorfstationen bleiben außerhalb der Erweiterung.
- Native Paper-Prüfung: OK: 12 harvest trees, 3 species, sawmill, walkable road, replant; no player rewards.
- 7 tatsächliche Weltblöcke einschließlich bisheriger Dorfstationen geprüft. 1 Spielerstand bytegleich zum Backup unmittelbar vor diesem Update.
- Aktuelles JAR installiert und mit dem Build verglichen. Ressourcenpaket unverändert; Serverstatus und HTTP-Packdownload geprüft. Aktueller Serverstart ohne ERROR-Einträge.
- Architekturvorschau aus dem echten Bauplan gerendert und angesehen. Keine Minecraft-Spielaufnahme. Native Blockprüfung simuliert kein Spieler-Halten der Maustaste; echte Client-Abnahme und langfristiges Wirtschaftsbalancing bleiben offen.

## Monster-Lebensanzeigen geprüft

- Drei neue Java-Tests für Balkenfüllung, Farbschwellen, echte Boss-Lebenspunkte, Rundung und ungültige Grenzwerte.
- Native Paper-Modellprüfung: DEEPFORGE COMBAT OK: 28 rigs, 196 bones, 112 poses including hit flashes, 4 damage labels, health plates: damage/heal/move/cleanup, 6 telegraphs; zero leaked entities; active=0.
- Dungeonprüfung mit Lebensanzeigen: OK: level 31, party 4, 8 waves, 156 enemies, 4 kinds, elites, boss, queued spawns, runes, healing item, 3 connected rooms, walkable gates, optional challenge, rescue, key chest, cleanup, chunk tickets.
- 1 Spielerstand bytegleich zum unmittelbar vorherigen Backup. Installiertes JAR entspricht dem Build; Pack unverändert; Serverlog ohne ERROR-Einträge.
- Lebensanzeigen bei Schaden, Heilung und Bewegung sowie Entfernung serverseitig geprüft. Keine visuelle Minecraft-Client-Abnahme.

## Wald und Menüführung geprüft

- Vorhandene Bauplantests für Oberflächengrenzen, unveränderte Dorfstationen, zu Fuß erreichbare Erntebäume/Sägewerk und getrennte dauerhafte Baumkronen bestanden.
- Native Menüprüfung auf Paper: OK: 23 reachable menu pages, fixed navigation, empty/ready saw, affordable/max upgrades; no player changes.
- Native Waldprüfung: OK: 12 harvest trees, 3 species, sawmill, walkable road, replant, pond, timber arch, log crane; no player rewards.
- 10 tatsächliche Weltblöcke einschließlich bisheriger Dorfstationen und neuer Walddekoration kontrolliert. 1 Spielerstand bytegleich zur Sicherung unmittelbar vor dem Update.
- Die erste native Menüprüfung fand eine von Paper als null zurückgegebene leere Beschreibung. Behandlung korrigiert und nach Neubau/Neustart vollständig erneut geprüft. Erster Diagnoseauszug: work/runtime/forest-menu-first-runtime.log.
- Installiertes JAR entspricht dem Build, Ressourcenpaket unverändert, abschließender Start ohne ERROR-Einträge. Bauplanvorschau angesehen; keine visuelle Minecraft-Client-Abnahme.

## TAB und Auto-Einstieg geprüft

- Sechs neue Tests: Erstlogin/Rückkehr, laufende Sitzung, Rechte/manueller Modus, Varo-/Netzwerkrangrechte, Hoster-Ausnahme bei Wildcards, Rangsortierung und persönliche Anzeigeformatierung.
- Native Paper-Prüfung: OK: 13 sidebar lines, unique entries, hidden score numbers, TAB components and cleanup; no player data.
- Menüprüfung: OK: 23 reachable menu pages, fixed navigation, empty/ready saw, affordable/max upgrades; no player changes.
- 1 Spielerstand sowie vorhandene config.yml bytegleich zur Sicherung vor dem Update. Aktuelles JAR installiert, Pack unverändert, Serverstart ohne ERROR-Einträge.
- Neue Optionen verwenden auch in einer bestehenden Konfiguration ohne diese Schlüssel ihre Standardwerte. Rangprüfung über die gleichen Bukkit-Permission-Nodes wie im Varo-Quellprojekt.
- Kein realer Clientlogin oder Test am externen LuckPerms-Netzwerk; native Prüfung erzeugt das Scoreboard ohne Spielerprofile zu verändern.

## Noch nicht durchgeführt

- Minecraft-Clientprüfung von Blockabbau, Modellansichten und GUI-Ausrichtung.
- Citizens-Laufzeittest der Skins, Navigation und Arbeiterinteraktionen.
- Mehrspieler-, Last- und langfristige Balancetests.

Der Download ist ein kompilierter Entwicklungsstand. Die Abnahme im Spiel und die weiteren Inhalte aus dem Gesamtkonzept stehen noch aus. Einzelheiten und Funktionsumfang: README.md.
