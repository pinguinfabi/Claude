# Neu in Deepforge 0.8.5 – Balance-Überarbeitung, Urboss, Sternenstein über dem Maximum

Beim Serverstart steht im Log `Deepforge 0.8.5 ready`. Ressourcenpaket unverändert (wie 0.8.1).

## Balance-Überarbeitung: Minen und Bosse deutlich schwerer
### Minenmonster
| Gebiet | Leben 0.7.1 → **jetzt** | Berührung → **jetzt** | Angriff → **jetzt** |
|---|---|---|---|
| 1 Eisenmine | 65 → **100** | 2,5 → **3,0** | 3,5 → **4,5** |
| 3 Pilztiefen | 156 → **256** | 4,9 → **6,3** | 6,9 → **9,5** |
| 5 Magmaschlucht | 375 → **655** | 9,6 → **13,3** | 13,4 → **19,9** |
| 7 Leerenbruch | 901 → **1.678** | 18,8 → **27,9** | 26,4 → **41,8** |

- **Leben:** +60 % pro Gebiet (vorher +55 %).
- **Schaden:** +45 % pro Gebiet (vorher +40 %).
- **Mehr Monster:** bis zu **5 gleichzeitig pro Spieler** (vorher 4).
- **Häufiger:** Sie erscheinen alle 8 Sekunden (vorher 10).
- **Schneller:** Sie schlagen bei Berührung öfter zu.

### Minenbosse
- **+60 % Leben.** Beispiele:
  - Eisenmine normal: 10.304 → **16.486**
  - Leerenbruch Albtraum: 153.530 → **245.647**
- Bosse **greifen schneller hintereinander an**, vor allem auf Veteran und Albtraum.
- Boss-Angriffe: **+35 % pro Gebiet** (vorher +30 %), höherer Grundschaden (5,5 → 7).
- Rundumschlag und Giftfelder wachsen genauso mit.

### Spielerseite: keine endlosen Stapel mehr
- **Runen sind pro Art gedeckelt** (egal wie viele Sockel):

  | Rune | Obergrenze |
  |---|---|
  | Kraft | +30 % |
  | Stein | +40 |
  | Leben | +40 |
  | Wind | +20 % |
  | Glück | +10 % |
  | Tiefe | +30 % |

  Vorher waren über 20 Sockel mit Kraftrune V rechnerisch +300 % möglich.
- **Krit-Chance max. 60 %** (vorher 100 %). Alles darüber wird zu Krit-Schaden.
- **Rüstung:** höchstens 60 % Schadensreduktion (vorher 65 %). Rüstungspunkte wirken etwas schwächer.
- **Dungeon-Beute wächst langsamer:** +6 % pro Level bis Level 31, danach +2 % pro Level (vorher unbegrenzt +7,5 %).

  | Dungeon-Level | Beutestärke vorher | jetzt |
  |---|---|---|
  | 20 | 2,42× | 2,14× |
  | 42 | 4,07× | 3,02× |
  | 80 | 6,92× | 3,78× |

  Die Gegner wachsen weiter mit +10 % Leben pro Level, hohe Dungeon-Level werden also wirklich schwer.
- **Arbeiter** (0.8.1 und 0.8.3): halbe Leistung, Lohn nach Warenwert, Pausen, max. 12 h offline.

## ☠ Der Urboss
- Nach einem Sieg über den **Leerenbruch-Boss auf Albtraum** erwacht mit **1 % Chance** der **Urboss**. „Der Boden bebt …“, nach 5 Sekunden beginnt ein **zweiter Kampf**.
- **Dreifaches Leben, +50 % Schaden**, lila Bossleiste. Alle Spieler auf dem Server werden benachrichtigt.
- **Beute:**
  - doppelte Boss-Beute
  - **ein garantiertes legendäres Teil (20 %: mythisch)**
  - 4 zusätzliche Runen
  - 150 Staub
  - 250.000 $
  - dreifache Ei-Chance
  - **2 % Sternenstein**. Das ist die **einzige** Quelle für Sternensteine.

## ✦ Sternenstein: eine Stufe über dem Maximum
- Normal ist bei **+10** Schluss. Ein Sternenstein hebt ein Teil auf **+11** („sternengeschmiedet“), mit **10 %** Chance. **90 %: das Teil zerbricht.**
- **Sternengeschmiedete Teile sind richtig stark:**
  - **doppelte Grundwerte** zusätzlich zum Stufenbonus
  - **Waffe:** Fähigkeit ×1,5 und **Sternenschlag**. 12 % der Treffer rufen einen Stern herab, der alle Gegner im Umkreis von 3,5 Blöcken trifft.
  - **Rüstung und Schmuck:** **Sternenschild**. Jedes Teil wehrt 4 % aller Treffer komplett ab (max. 20 %).
  - **Sternen-Aura:** Lichtspirale um den Träger (für alle sichtbar), goldene Funken an der Waffe.
- **Beim Gelingen:** Blitz, Totem-Effekt, Feuerwerk und eine Nachricht an den ganzen Server. Beim Zerbrechen: Splitter und Amboss-Krach.

## „Nächstes Ziel“ geht jetzt weiter
Der Ziele-Knopf endete bisher bei „Erschließe alle sieben Gebiete“. Jetzt gibt es 8 weitere Endgame-Ziele mit hohen Belohnungen (10.000–80.000 $, Relikte, Staub):
1. Leerenbruch-Boss besiegen
2. Dungeon auf Albtraum gewinnen
3. 25 Champions besiegen
4. Meisterschaft 15
5. Dungeon-Level 30
6. Leerenbruch-Boss auf Albtraum besiegen
7. Gegenstand über das Maximum schmieden
8. Den Urboss besiegen

## Admin-Testbefehle
- `/df admin urboss`: Nach deinem nächsten Leerenbruch-Albtraum-Sieg erwacht sicher der Urboss.
- `/df admin urboss jetzt`: Der Urboss erscheint sofort in deiner aktuellen Mine.
- `/df admin sternenstein`: +3 Sternensteine.
