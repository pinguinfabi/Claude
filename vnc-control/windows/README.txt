Minecraft VNC Control – Windows
================================

Voraussetzungen
---------------
1. Das Serverpaket muss einmal auf dem Ubuntu-Server installiert worden sein.
2. TigerVNC Viewer muss installiert sein. Standardpfad:
   C:\Program Files\TigerVNC\vncviewer.exe

Benutzung
---------
1. Minecraft-VNC-Control.exe starten.
2. Server 173.249.38.29, Port 22 und Benutzer vncguest stehen bereits drin.
3. Das eigens für vncguest gesetzte Passwort eingeben.
4. Beim ersten Start den angezeigten SSH-Fingerabdruck mit der Ausgabe des
   Server-Installers vergleichen und erst dann bestätigen.
5. Verbinden anklicken.
6. Alle VNC-Fenster öffnen oder einen einzelnen Account öffnen.
7. Neu starten startet ausschließlich den ausgewählten Minecraft-Client neu.

Sicherheit
----------
- Das Passwort wird nicht gespeichert.
- Die App speichert nur Serveradresse, Benutzer, TigerVNC-Pfad und den
  bestätigten SSH-Fingerabdruck unter:
  %LOCALAPPDATA%\MinecraftVncControl\settings.json
- Der Benutzer vncguest besitzt keine normale Shell und darf ausschließlich
  die sechs lokalen VNC-Ports (5902 bis 5907) weiterleiten sowie feste Status-/Neustartbefehle
  ausführen.
- Niemals das normale Linux-Passwort des Benutzers autosell weitergeben.

Fehlerbehebung
--------------
- "Anmeldung abgelehnt": Passwort von vncguest prüfen.
- "Server nicht erreichbar": SSH-Port 22/Firewall und Server-IP prüfen.
- TigerVNC fehlt: Unten über "Auswählen …" vncviewer.exe auswählen.
- SSH-Schlüssel geändert: Nicht blind bestätigen. Auf dem Server mit
  ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub -E sha256 prüfen.

Version 1.3.0
-------------
- Neues dunkles Design, sechs Accounts: afk2 (Crafter) und afk3 bis afk7.
- Namen und Notizen pro Account mit dem Stift-Knopf ändern. Sie werden in
  settings.json gespeichert (nur auf diesem PC).
- Gestoppte Clients (z. B. noch ohne Account-Login) werden nie automatisch
  gestartet; nur eine ausgefallene VNC-Brücke wird automatisch repariert.
- Neuer Standardserver 173.249.38.29. Der SSH-Fingerabdruck wird je Server
  gespeichert und beim ersten Verbinden neu bestätigt.

Selbst bauen (nur wenn das .NET 9 SDK installiert ist)
------------------------------------------------------
  cd MinecraftVncControl
  dotnet publish -c Release -r win-x64 -o ..\release

Version 1.5.0 – Update-Paket
----------------------------
Die App zeigt 12 Kacheln in drei Gruppen:
- PRISM (VNC): afk1 (Port 5901, bisheriger afk3) und afk2 (Port 5902, neu und leer).
- JAVA-CHAT-BOTS: j1 bis j5  (kein VNC)
- BEDROCK-CHAT-BOTS: b1 bis b5  (kein VNC)
Alle Bots joinen hugosmp.net, loggen sich bei Kick/Abbruch automatisch neu ein (Relog)
und haben einen "Chat"-Knopf: Fenster wie der Minecraft-Chat (mitlesen, schreiben,
/befehle senden). Namen/Notizen aller Kacheln mit dem Stift aendern.

Server-Einrichtung: server/update-setup.sh als root ausfuehren (einmalig), danach pro Bot
"bot-login j1" ... (Microsoft-Code im Browser eingeben). Neuer Prism-Platz afk2: Konto per
setup-gui.sh anmelden (siehe Ende der Skript-Ausgabe).
