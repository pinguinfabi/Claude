# Neu in Deepforge 0.8.0 – Runen & Champions

Beim Serverstart steht im Log `Deepforge 0.8.0 ready`. Ressourcenpaket unverändert (wie 0.7.0). Es reicht, die neue Jar einzuspielen.

## ✦ Champions in den Minen
Etwa **jedes 12. Monster** (8 %) in den Minen ist ein **Champion**:
- Er ist größer, hat eine leuchtende Aura in seiner Farbe und **2,5× Leben**.
- Er macht **+35 % Schaden**.
- Beim Erscheinen kündigt der Chat ihn mit Namen und Eigenschaften an.

**Eigenschaften:** In den oberen Minen hat ein Champion eine, ab der 4. Mine oft zwei.

| Eigenschaft | Wirkung |
|---|---|
| **Gepanzert** | nimmt 40 % weniger Schaden |
| **Rasend** | schneller und greift fast doppelt so oft an |
| **Vampir** | heilt sich bei jedem Treffer an dir um 6 % seines Lebens |
| **Brennend** | +50 % Schaden, setzt dich in Brand |
| **Frostig** | verlangsamt dich bei Berührung |
| **Riese** | doppeltes Leben (also 5×), noch größer |

**Beute pro Champion:**
- **1 Rune sicher**, 25 % Chance auf eine zweite
- **120 $ × Gebiet** extra
- 50 % Chance auf Ausrüstung (selten oder episch)
- **30 Tiefenpass-XP**

Neues **Weltereignis „Championjagd“:** Für 10 Minuten gibt es **viermal so viele Champions** (32 %).

## Runen – 6 Arten, 5 Stufen
| Rune | Wirkung pro Stufe (I → V) |
|---|---|
| **Kraftrune** | +3 % Schaden (V: +15 %) |
| **Steinrune** | +4 Rüstung (V: +20) |
| **Lebensrune** | +4 Leben (V: +20) |
| **Windrune** | +2,5 % Angriffstempo (V: +12,5 %) |
| **Glücksrune** | +1,5 % Krit-Chance (V: +7,5 %) |
| **Tiefenrune** | +3 % Abbautempo (V: +15 %) |

**Woher kommen Runen?**
- **Champions:** 1–2 Runen
- **Minenbosse:** 2 Runen
- **Jeder Dungeon-Sieg:** 1 Rune, je höher Gebiet, Level und Schwierigkeit, desto höher die Stufe
- **Normale Monster:** 2 % Chance
- **Stufe nach Gebiet:** In der Eisenmine findest du Stufe I–II, im Leerenbruch Stufe IV–V.

**Runenbeutel:** `/df runen` oder Kampf → **Runen**. Dort siehst du alle Runen nach Art und Stufe.

**Runenschmiede:** Klick auf eine Runenart, dann ergeben **3 gleiche Runen + etwas Staub 1 Rune der nächsten Stufe** (I → II → … → V).

## Sockel in der Ausrüstung
- **Neue epische Beute hat 1 leeren Sockel, legendäre und mythische 2.**
- **Sockel bohren:** Gegenstand im Beutel öffnen → **„Sockel bohren“** (Spitzhacke).
  - Ungewöhnlich und selten: bis 1 Sockel
  - Episch und besser: bis 2 Sockel
  - Kosten: 1.500 $ × Gebiet × Sockelnummer plus Staub
  - Ältere Gegenstände bekommen ihre Sockel so nachträglich.
- **Rune einsetzen:** Klick auf einen leeren Sockel (Glasscheibe) öffnet den Runenbeutel. Ein Klick setzt die Rune ein.
- **Rune herauslösen:** Klick auf einen belegten Sockel. Das kostet etwas Staub, die Rune kommt zurück in den Beutel.
- Runen wirken, solange der Gegenstand angelegt ist. Lebensrunen zählen **zusätzlich** zur normalen Lebensgrenze.
- Die Beutel-Ansicht zeigt die Sockel jedes Teils, z. B. `Sockel: [Kraftrune III] [leer]`.

## Kleinigkeiten
- Das Dungeon-Beuteprotokoll listet gefundene Runen mit auf.
- Das Kampfmenü zeigt, wie viele Champions du schon besiegt hast.
- Admin-Testbefehle:
  - `/df admin champion` erzeugt einen Champion neben dir (nur in einer Mine).
  - `/df admin runen` gibt je 3× Stufe-I-Runen.
  - `/df admin event championjagd` startet das neue Weltereignis.
