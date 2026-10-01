# Neu in Deepforge 0.5.3

Beim Serverstart steht im Log `Deepforge 0.5.3 ready`. Ressourcenpaket unverändert (wie 0.5.2).

## Monster-Modelle (Köpfe) repariert
- **Kopf/Körper bleiben am Monster:** Im Dungeon wurden die Modellteile nur während der Kämpfe mitbewegt.
  Wurde ein Monster in einer Pause geschubst oder stand gerade keiner, hing das Modell danach hinterher oder
  blieb stehen. Jetzt folgen alle Teile dem Monster in jeder Phase (Test: höchstens 0,34 Blöcke Abstand).
- **Mitspieler sehen die Monster wieder:** In der geteilten Mine sah ein Spieler, der später in einen Kampf
  kam oder sich neu eingeloggt hat, das Monster-Modell nicht (und den unsichtbaren Mob darunter auch nicht).
  Die Teile werden jetzt jede Sekunde allen aktuellen Kämpfern gezeigt.
