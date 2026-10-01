# Bossleben und Reaktion auf Rückenangriffe

## Neue Lebenswerte

Gegenüber dem vorherigen Entwicklungsstand haben Minenbosse **8×**, Dungeonbosse **12×** und normale Dungeon-Gegner **4×** so viel Leben. Eliten behalten ihren zusätzlichen Faktor 1,6. Die regulären Monster in den Minen sind unverändert.

| Normal, erstes Gebiet | Vorher | Jetzt |
|---|---:|---:|
| Minenboss | 1.120 LP | 8.960 LP |
| Dungeonboss, Level 1, solo | 500 LP | 6.000 LP |
| Dungeonboss, Level 1, vier Spieler | 1.250 LP | 21.300 LP |
| Dungeon-Gegner, erste Welle, Level 1, solo | 28 LP | 112 LP |
| Dungeonboss, Level 31, vier Spieler | 5.000 LP | 85.200 LP |

Dungeonleben steigt weiterhin um 10 % des Ausgangswerts pro Level. Jedes zusätzliche Gruppenmitglied erhöht das Leben jetzt um **85 %** statt 50 %. Die Anzahl der Gegner steigt zusätzlich; Schaden und Beute behalten ihre bisherigen Formeln. Die Gruppengröße bleibt beim Start festgeschrieben.

Damit die längeren Kämpfe in den Ablauf passen, stehen für Minenbosse **12 Minuten**, für vollständige Dungeons **30 Minuten** zur Verfügung. Die Menüs und Restzeitanzeigen nutzen dieselben Konstanten wie der Kampf.

## Hinter dem Boss ist kein dauerhafter sicherer Platz

Drei nahe Treffer von hinten mit höchstens drei Sekunden Pause zwischen den Treffern provozieren einen **Rundumschlag**, unabhängig vom Waffentyp. Der Boss beendet zunächst eine bereits angekündigte Attacke und kündigt den Konter dann mit rotem Kreis, Ton und Text an. Zu alte Rückenangriffe verfallen.

Die Warnung dauert **1,4 Sekunden**. Der Kreis ist **4,5 Blöcke** groß, trifft in alle Richtungen und bleibt während der Warnung an derselben Stelle. Auch hinter dem Boss und beim normalen Springen kann man getroffen werden. Verlasse den Kreis oder nutze Ausweichen beziehungsweise Parade. Wände blockieren den Treffer. Im Dungeon sind alle noch kämpfenden Gruppenmitglieder im Kreis gefährdet.

Treffer während der Warnung verursachen weiter Schaden, verschieben aber weder den Kreis noch den Ausführungszeitpunkt. Der Konter hat nach Ausführung sieben Sekunden Erholung; dadurch kann eine Gruppe keine Kette von Kontern auslösen. Getrennte Bossinstanzen haben getrennte Zustände. Normale Angriffswarnungen werden nicht vom Konter abgeschnitten.

Minenbosse sind nach Ende eines Haltungsbruchs **sechs Sekunden standfest**: normaler Schaden bleibt möglich, weiterer Haltungsaufbau beginnt erst danach. Der bereits bestehende offene Kern bleibt 4,5 Sekunden verwundbar. So können schnelle Treffer den Boss nicht nahezu dauerhaft im Haltungsbruch halten. Die Bossleiste zeigt die Standfestigkeit an. Rückstoß bleibt sichtbar, pausiert Minenbosse aber nur noch kurz. Vor normalen Angriffen richten sich Bosse zum anvisierten Ziel aus; die angekündigte Angriffsrichtung bleibt danach fest.

Der schnelle Nahkampf bleibt erhalten. Dolche behalten ihren Rückenbonus von 65 %, verlangen dafür aber Positionswechsel. Lebenssplitter funktionieren weiter im Kampf (`/df heal`).

Eigene Minen- und Dungeon-Gegner werden ohne zufällige Vanilla-Spawnvarianten erzeugt: keine Hühnerreiter, keine Babyvarianten und keine zufällige Rüstung. Dadurch passen Trefferbox und Bewegung zur vorgesehenen Kreatur.

## Prüfung

Automatisierte Tests prüfen Rückenangriffsschwelle, Reichweite, abgelaufene Treffer, vollständige Warnzeit trotz weiterer Treffer, Konterpause, Fluchtgrenze, Standfestigkeit und Lebensskalierung. Eine Level-4-Dolchkonfiguration mit Tempo und Krit-Boni dient als Regressionstest gegen kurze Schadensbursts; das ist eine Rechnung mit zehn Treffern pro Sekunde, kein gespielter Kampf.

Der Paper-Dungeon-Diagnoselauf prüft weiterhin echte Gegnerinstanzen, Modelle, acht Wellen, Nachspawns und Bereinigung mit simulierter Vierergruppe. Spielgefühl, erfolgreiche Ausweichmanöver und tatsächliche Kampfdauer müssen im Minecraft-Client erprobt werden.
