# Neu in Deepforge 0.4.3

Beim Serverstart steht im Log `Deepforge 0.4.3 ready`. Ressourcenpaket unverändert (wie 0.4.0).

## Krit-Chance bis 100 %
- Die Grenze lag bei 50 %, jetzt bei **100 %**.
- Krit-Chance über 100 % wird zu zusätzlichem Krit-Schaden (1 % Chance = 1 % Schaden, höchstens +100 %).

## Krit-Schaden pro Waffe
Krit-Schaden = **Grundwert des Waffentyps + Krit-Schaden-Bonus der Waffe** (+ Bonus von Ringen/Amulett usw.).

| Waffentyp | Grund-Krit-Schaden |
|---|---|
| Dolch | 200 % |
| Armbrust | 190 % |
| Speer | 180 % |
| Schwert | 175 % |
| Hammer | 150 % (dafür viel Grundschaden) |
| Prismenklinge (Unikat) | 210 % |

Bonus auf der Waffe nach Seltenheit (× Qualität):

| Seltenheit | Krit-Schaden-Bonus |
|---|---|
| Ungewöhnlich | +5 – 15 % |
| Selten | +10 – 25 % |
| Episch | +15 – 35 % |
| Legendär | +20 – 45 % |
| Mythisch | +30 – 60 % |

- Andere Ausrüstung kann Krit-Schaden als Zusatzwert haben.
- **Neu schmieden:** Waffe öffnen → „Krit-Schaden neu schmieden“ (gleiche Kosten wie der Krit-Reroll: Geld + 5 Staub).
- Vorhandene Waffen bekommen einmalig die **Mitte** ihres Bonus-Bereichs.
- Jeder Gegenstand zeigt seinen Krit-Schaden; der Vergleich mit der ausgerüsteten Waffe listet ihn mit (▲/▼).

## Dungeon: jeder bekommt anderen Loot
- In einer Party bekommt jeder Spieler aus demselben Lauf eine **andere Art von Ausrüstung** (Waffe, Helm, Ring, …).
- Seltenheit und Werte werden weiterhin für jeden einzeln gewürfelt.
