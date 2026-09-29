# TAB, Ränge und automatischer Einstieg

TAB-Liste und Infotafel verwenden das Design aus deinem Varo-Projekt: **Axxin.de ● Deepforge**, silberner Verlauf, weißer Spielname, graue Beschriftungen mit `▸`, dezente Trenner und der violette Community-Link. Der Varo-Quellordner wurde als Vorlage gelesen und nicht verändert.

Die TAB-Liste enthält echte Online-Spieler mit Rangpräfix, Rangfarbe und Rangsortierung. Kopf/Fuß zeigen Netzwerk, Spielmodus, sichtbare Spielerzahl, Verbindung, eigenes Geld und Dungeonlevel. Keine künstlichen Spieler oder festen Namensplatzhalter. Die rechte Infotafel zeigt persönlichen Geld-, Gebiets-, Dungeon-, Gegner-, Rucksack-, Holzlager-, Arbeiter- und Heilungsfortschritt. Aktualisierung einmal pro Sekunde; unveränderte Texte werden nicht neu gesendet.

## LuckPerms-Ränge wie in Varo

Die Rangprüfung nutzt dieselben Bukkit-Berechtigungen wie Varo. LuckPerms stellt sie über die vorhandenen Benutzer-/Gruppenrechte bereit; es werden keine Gruppen erstellt, vergeben oder geändert.

| Rang | Farbe | Bevorzugtes Recht |
|---|---|---|
| ADMIN | Dunkelrot | `network.rank.admin` |
| TEAMLEITUNG | Rot | `network.rank.teamleitung` |
| DEV | Aqua | `network.rank.dev` |
| SRMOD | Blau | `network.rank.srmod` |
| MOD | Dunkelaqua | `network.rank.mod` |
| HELPER | Grün | `network.rank.helper` |
| BUILDER | Gelb | `network.rank.builder` |
| MEDIA | Rosa | `network.rank.media` |
| VIP | Gold | `network.rank.vip` |
| SUB | Violett | `network.rank.sub` |
| Normaler Spieler | Grau, ohne Präfix | kein Rangrecht |

Alternativ funktionieren jeweils `varo.<rang>` und `deepforge.rank.<rang>`. Der höchste passende Rang gewinnt; Spielernamen behalten die Rangfarbe. Wie im Varo-Code sind die Präfixe fest definiert, nicht aus beliebigen LP-Meta-Prefixen zusammengesetzt.

Beispiel für eine bereits vorhandene LP-Gruppe: `lp group admin permission set network.rank.admin true`. Das Update übernimmt vorhandene Rechte; dieser Befehl ist nur nötig, wenn die Gruppe noch kein solches Recht hat. Ein Gruppenname allein ohne Rangrecht genügt genauso wie in Varo nicht.

**HOSTER** ist weiß/fett und steht ganz oben. Er wird ausdrücklich über `display.hosters` (Liste von UUIDs oder Spielernamen) markiert. Ein Wildcard-Recht `*` macht nicht alle Administratoren zum Hoster. Diese Kennzeichnung vergibt selbst keinerlei Administrationsrechte. Der Varo-Befehl `/hoster` und seine Spielerdaten werden nicht importiert.

## Automatischer Einstieg

- Neue Spieler mit `deepforge.play` starten beim Login automatisch. Das Recht ist standardmäßig für Spieler aktiv.
- Bestehende Spieler werden fortgesetzt; nach einem Login aus einer anderen Welt betreten sie Deepforge automatisch.
- Die normale Starterausrüstung und die bestehende Speicherung werden verwendet. Wiederholte Login-Ereignisse starten keine zweite Sitzung.
- Bei vollem Inventar wartet der Einstieg, bis genügend Plätze frei sind. Vorhandene Gegenstände werden nicht gelöscht; der nächste Versuch erfolgt automatisch einmal pro Sekunde.
- `/df leave` verlässt die Sitzung. Beim nächsten Login greift wieder der automatische Einstieg; `/df start` bleibt optional für den manuellen Wiedereintritt verfügbar.
- Mit `game.auto-join: false` kann ein Betreiber den ursprünglichen manuellen Eintritt wieder aktivieren.

## Einstellungen

Neue Optionen sind auch bei älteren Konfigurationen ohne diese Einträge automatisch aktiv. Ein Update muss die vorhandene `config.yml` daher nicht ersetzen. Bei Bedarf ergänzen:

```yaml
game:
  auto-join: true
display:
  tab-list: true
  sidebar: true
  network-name: 'Axxin.de'
  social: 'twitch.tv/fabiderpinguin'
  hosters: []
```

In einer bestehenden Datei `auto-join` unter den bereits vorhandenen `game`-Abschnitt setzen, keinen zweiten Abschnitt anlegen. Bei einem anderen Plugin für TAB/Sidebar kann der jeweilige Deepforge-Teil separat deaktiviert werden. Vorherige Anzeigen werden bei regulärem Verlassen/Deaktivieren wiederhergestellt, sofern sie noch von Deepforge verwaltet werden.

Ressourcenpaket und Weltformat bleiben gleich. Dieses Update erhält Fortschritt, LP-Daten, Ressourcenpaket-URL und Welten. Für einen laufenden Server ist ein regulärer Stop/Start zum Laden der neuen JAR erforderlich; kein Hot-Reload.

Tests prüfen Login-Entscheidungen, Rangrechte/Sortierung/Wildcard-Ausnahme, Werteformatierung und die native Paper-Scoreboard-Erstellung. Ein echter Clientlogin, die optische TAB-Abnahme und eine Anmeldung über das externe LuckPerms-Netzwerk sind noch nicht durchgeführt.
