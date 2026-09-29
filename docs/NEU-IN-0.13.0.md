# Neu in Deepforge 0.13.0 – Alchemie & Tränke

Beim Serverstart steht im Log `Deepforge 0.13.0 ready`.

Zum Ressourcenpaket:
- Es gibt ein **neues Ressourcenpaket** mit 10 neuen Icons: Braustand, 6 Trankflaschen und 3 Zutaten.
- Die SHA-1 steht in `resourcepack/pack.sha1` und ist in `config.yml` schon eingetragen.

## ⚗ Alchemie
**Öffnen:** Hauptmenü → **Braustand oben links** oder `/df alchemie` (auch `/df tränke`).

### Zutaten – jede Arbeit liefert eine
| Zutat | Woher |
|---|---|
| **Schattenessenz** | Minenmonster 10 % · Champion 3 · Gebietsboss 5 · Dungeon-Sieg 2 + Schwierigkeit |
| **Glutmoos** | beim Erzabbau, 2 % pro Erzblock (mit Hinweis im Chat) |
| **Waldkraut** | beim Baumfällen, 20 % pro Baum |

### Die 6 Tränke
- **Linksklick** auf einen Trank: brauen
- **Rechtsklick**: trinken

| Trank | Wirkung | Dauer | Rezept (Essenz / Moos / Kraut) |
|---|---|---|---|
| Trank der Stärke | +15 % Schaden | 10 Min. | 3 / 0 / 2 |
| Trank der Zähigkeit | +15 % Leben | 10 Min. | 2 / 0 / 3 |
| Bergmannstrank | +20 % Abbaukraft | 15 Min. | 0 / 3 / 2 |
| Goldtrank | +20 % Erz- und Barrenwert (auch Händler-Arbeiter) | 15 Min. | 1 / 4 / 1 |
| Flinktrank | +0,30 Angriffstempo | 10 Min. | 3 / 1 / 1 |
| Tiefenschutz | −20 % erlittener Schaden (Minen und Dungeons) | 8 Min. | 4 / 2 / 2 |

Zum Brauen gilt:
- **Geldkosten:** 300 $ × Gebiet, bei stärkeren Tränken ×2 oder ×3. Sie wachsen also mit dem Fortschritt.
- **Nachtrinken** verlängert die Wirkung bis höchstens zur doppelten Dauer.
- **Wenn die Wirkung endet**, kommt ein kurzer Hinweis im Chat.
- **Gleichzeitig** gehen zuerst **2 Tränke**. Mehr gibt es über die Braumeister-Stufe.

### Braumeister-Stufe
| | |
|---|---|
| XP | +10 pro Brauen; Stufe n braucht 40 × n² XP (Stufe 5: 1.000, Stufe 10: 4.000, Stufe 20: 16.000) |
| Trankstärke | +2 % pro Stufe (Stufe 20: +40 %, also Stärke-Trank +21 %) |
| Gleichzeitig aktiv | 2, +1 bei Stufe 5, 10, 15 und 20 (bis 6) |
| Ab Stufe 10 | 2 Tränke pro Brauen |

Tränke passen zu Prestige: Je härter die Welt, desto mehr lohnt sich ein Stärke- oder Schutztrank vor dem Bosskampf.

## 📖 Wiki
Die neue Seite **„Alchemie & Tränke“** zeigt:
- alle Zutaten mit Quelle
- alle Tränke mit Wirkung und Rezept
- die Braumeister-Stufen

Der Hilfe-Knopf im Alchemie-Menü öffnet sie direkt.

## Getestet
- **300 Unit-Tests** grün, 6 neue für Alchemie:
  - Brauen braucht Zutaten und Geld
  - Wirkung und Ablauf, Nachtrinken, Höchstdauer
  - Limit gleichzeitiger Tränke
  - Braumeister-Stufen
  - Tränke wirken auf Schaden, Abbaukraft und Verkaufspreis
  - Waldkraut vom Baumfällen, Wiki-Seite
- **Live mit Bot:**
  - Hauptmenü zeigt den Braustand.
  - Zweimal Stärke gebraut, getrunken: „+15 % Schaden für 10 Min.“
  - Flinktrank gebraut und getrunken.
  - Trinken ohne Vorrat wird abgelehnt.
  - Das Menü zeigt „AKTIV · noch 9:55“ und „Aktiv: 2 / 2“.
  - Keine Fehler im Server-Log.
