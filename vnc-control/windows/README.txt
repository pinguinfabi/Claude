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
2. Server 178.105.144.81, Port 22 und Benutzer vncguest stehen bereits drin.
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
  die fünf lokalen VNC-Ports weiterleiten sowie feste Status-/Neustartbefehle
  ausführen.
- Niemals das normale Linux-Passwort des Benutzers autosell weitergeben.

Fehlerbehebung
--------------
- "Anmeldung abgelehnt": Passwort von vncguest prüfen.
- "Server nicht erreichbar": SSH-Port 22/Firewall und Server-IP prüfen.
- TigerVNC fehlt: Unten über "Auswählen …" vncviewer.exe auswählen.
- SSH-Schlüssel geändert: Nicht blind bestätigen. Auf dem Server mit
  ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub -E sha256 prüfen.
