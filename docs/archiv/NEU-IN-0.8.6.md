# Neu in Deepforge 0.8.6 – wichtiger Hotfix

Beim Serverstart steht im Log `Deepforge 0.8.6 ready`. Ressourcenpaket unverändert (wie 0.8.1).

## Behoben: Spielstand mit Sternenstein-Gegenstand ließ sich nicht laden
- In 0.8.5 konnte ein Gegenstand per Sternenstein auf **+11** steigen. Die Spielstand-Prüfung erlaubte aber nur bis **+10**.
- Folge: Ein Spieler mit so einem Teil wäre nach dem nächsten Neustart mit „Ungültiger Spielerstand“ abgewiesen worden.
- Jetzt sind +11-Teile erlaubt und überstehen Neustarts (mit Test abgesichert).
- **Bitte 0.8.6 direkt statt 0.8.5 einspielen.**
