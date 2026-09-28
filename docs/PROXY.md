# Deepforge-Proxy (BungeeCord / Waterfall)

Damit können Spieler auf **jedem Server im Netzwerk** `/deepforge` (oder `/df`) eingeben und werden zum
Deepforge-Server geschickt. Auf dem Deepforge-Server selbst gehen die Befehle ganz normal an Deepforge
(`/df menu`, `/df daily` … funktionieren dort wie immer).

## Installation
1. `proxy/DeepforgeProxy.jar` in den `plugins`-Ordner des **Proxys** (BungeeCord oder Waterfall) legen.
   Nicht auf den Deepforge-Server!
2. Proxy neu starten. Es entsteht `plugins/DeepforgeProxy/config.yml`.
3. `server:` muss genau so heißen wie der Deepforge-Server unter `servers:` in der Proxy-`config.yml`
   (Standard: `deepforge`).
4. Auf dem Deepforge-Server (Paper) wie bei jedem Bungee-Server: in `spigot.yml` `settings.bungeecord: true`,
   in `server.properties` `online-mode=false`, und in der Proxy-`config.yml` `ip_forward: true`.

## Berechtigung
Standard-Recht: `deepforge.join` (in der config änderbar; leer lassen = alle dürfen).

- Mit **LuckPerms auf dem Proxy** (LuckPerms-Bungee):
  `/lpb group default permission set deepforge.join true` → alle dürfen,
  oder nur eine Gruppe: `/lpb group spieler permission set deepforge.join true`.
- Ohne LuckPerms in der Proxy-`config.yml`:
  ```yaml
  groups:
    DeinName:
    - deepforge
  permissions:
    deepforge:
    - deepforge.join
  ```

Ohne Recht kommt: „Du darfst Deepforge noch nicht betreten.“

`restrict-server: true` sperrt Spieler ohne Recht auch für `/server deepforge` und andere Wege.

## Befehle
- `/deepforge`, `/df` – zum Deepforge-Server (Befehle in `commands:` änderbar)
- `/dfproxy` (Recht `deepforge.proxy.admin`) – config neu laden

## Getestet
BungeeCord (aktuell) mit einer Paper-Lobby und dem Deepforge-Server 1.21.8:
- mit Recht: `/deepforge` in der Lobby → auf Deepforge verbunden, dort öffnet `/df menu` das Hauptmenü
- ohne Recht: Meldung, bleibt in der Lobby
- `restrict-server: true`: `/server deepforge` ohne Recht wird geblockt

Die Nachrichten (mit `&`-Farbcodes) stehen unter `messages:` in der config.
