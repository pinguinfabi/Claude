# Neu in Deepforge 0.22.2 – Twitch-Link: twitch.tv/axxin_live

Beim Serverstart steht im Log `Deepforge 0.22.2 ready`. **Das Ressourcenpaket bleibt gleich** (wie 0.20.0). Nur `plugins/Deepforge.jar` ersetzen.

## 📺 Tab-Liste: twitch.tv/axxin_live
- Unten in der Tab-Liste steht jetzt **twitch.tv/axxin_live** statt twitch.tv/fabiderpinguin.
- **Du musst nichts tun:** Steht in deiner laufenden `plugins/Deepforge/config.yml` noch der alte Standardwert, ersetzt Deepforge ihn beim Start einmal automatisch. Im Log steht dann: `display.social auf twitch.tv/axxin_live aktualisiert.`
- Hast du dort einen eigenen Wert eingetragen, bleibt er unverändert.
- Die Kommentare in der config.yml bleiben erhalten.
- Die mitgelieferte `config.yml` und `docs/TAB-UND-AUTOLOGIN.md` sind ebenfalls angepasst.

## Getestet
- **349 Unit-Tests** grün.
- **Live:** Testserver mit altem Wert in der config.yml gestartet:
  - Log-Meldung erscheint.
  - config.yml enthält danach `twitch.tv/axxin_live`, alle Kommentare sind noch da.
  - Die Tab-Liste des Test-Bots zeigt `twitch.tv/axxin_live`.
