# Neu in Deepforge 0.7.3

Beim Serverstart steht im Log `Deepforge 0.7.3 ready`. Ressourcenpaket unverändert (wie 0.7.0).

## Ausrüstungs-Sets bearbeiten, Teile entfernen, Sets leeren
Unter Charakter → **Ausrüstungs-Sets** (oder `/df sets`):

- **Set bearbeiten:** Klick auf das Set-Symbol öffnet den Editor mit allen 10 Plätzen (Waffe, Nebenhand, Helm, …).
  - **Platz anklicken** zeigt alle passenden Teile aus deinem Beutel (die besten zuerst). Ein Klick übernimmt das Teil ins Set und ersetzt das alte.
  - **Roter Farbstoff unter einem Platz** nimmt das Teil **aus dem Set**. Das Teil selbst bleibt im Beutel bzw. angelegt.
  - **Smaragd oben rechts:** Set auf aktiv stellen.
- **Set leeren:** Barriere über jedem Set oder `/df sets leeren <1-4>`. Der Name bleibt, die Ausrüstung bleibt angelegt, nur das Set ist danach leer (und der Verkaufsschutz für diese Teile entfällt).
- Weiterhin:
  - „Aktuelle Ausrüstung speichern“ (Buch)
  - „Auf aktiv stellen“ (Smaragd)
  - `/df sets name <1-4> <Name>`

## Übersicht der Set-Befehle
| Befehl | Wirkung |
|---|---|
| `/df sets` | Übersicht öffnen |
| `/df sets 2` oder `/df sets Mining` | Set auf aktiv stellen |
| `/df sets speichern 2` | aktuelle Ausrüstung als Set 2 speichern |
| `/df sets leeren 2` | Set 2 leeren |
| `/df sets name 2 Bossjagd` | Set 2 umbenennen |
