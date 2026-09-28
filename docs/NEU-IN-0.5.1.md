# Neu in Deepforge 0.5.1

Beim Serverstart steht im Log `Deepforge 0.5.1 ready`.
**Neues Ressourcenpaket** (SHA-1 `3b9ae4c4a679738b101dd0f0e8e18988c8252eaf`). Mit Self-Host oder leerem `sha1:`
kommt es automatisch. Wer es selbst hostet: `resourcepack/Deepforge-ResourcePack.zip` neu hochladen und die
neue SHA-1 in `plugins/Deepforge/config.yml` eintragen (steht dort schon).

## Tabliste, Scoreboard und Nametags im Pinguin-Netzwerk-Style
Die Grafiken kommen aus dem Netzwerk-Pack (`netzwerk-pack.zip`): Rang-Tags, Status-Tags, Icons und Trenner.
Dazu gibt es neu gezeichnet im gleichen Pixel-Style das große **DEEPFORGE**-Logo und den Panel-Header
**◆ DEEPFORGE ◆ / PINGUIN NETZWERK** (genau wie „LOBBY“ im Lobby-Pack).

- **Scoreboard rechts:** Titel ist der orange DEEPFORGE-Panel-Header. Die Infos (Geld, Schmiedestaub, Gebiet,
  Gewölbe, Gegner, Rucksack, Holzlager, Arbeiter, Heilsplitter, Tagesaufträge) stehen weiter da, jetzt mit den
  Netzwerk-Icons (Stern, Zone, Krone, Totenkopf, Team, Herz) und orangen Trennlinien.
- **Tabliste oben:** großes DEEPFORGE-Logo, darunter „PINGUIN NETZWERK“ und eine orange Linie.
- **Tabliste unten:** Spieler, Ping, Geld, Gewölbe-Level, Treffer, Krit – jeweils mit Icon –, dazu Handbuch-Hinweis
  und der Twitch-Link mit Twitch-Icon.
- **Nametags und Namen in der Tabliste:** der farbige Rang-Tag aus dem Netzwerk (ADMIN, MOD, VIP …) vor dem Namen,
  der Name in Rangfarbe. Dahinter:
  - **INGAME**-Tag, wenn der Spieler gerade in einem Dungeon ist
  - **SPEC**-Tag, wenn er zuschaut oder im Admin-Modus ist
- Ränge wie bisher über die Rechte `network.rank.<rang>` (bzw. `varo.<rang>` / `deepforge.rank.<rang>`), HOSTER
  über `display.hosters` – siehe `docs/TAB-UND-AUTOLOGIN.md`.

**Ohne Ressourcenpaket** (abgelehnt oder `/df hud text`) sieht jeder Spieler dieselben Infos als Text im bisherigen
Netzwerk-Design („ADMIN Name“, „[Dungeon]“, „[Zuschauer]“). Das wird pro Zuschauer entschieden: Jeder sieht die
Variante, die sein Client darstellen kann.

Hinweis: Das Lobby-Plugin-Repository (`Fabiderpinguin/lobby`) war für mich nicht erreichbar, weil es privat ist
bzw. kein Zugriff bestand. Den Style habe ich deshalb direkt aus dem Netzwerk-Pack übernommen: Logo, Header,
Tags und Icons sind dieselben Grafiken bzw. im selben Raster gezeichnet.
