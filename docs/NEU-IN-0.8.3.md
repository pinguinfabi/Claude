# Neu in Deepforge 0.8.3 – Waffen-Fähigkeiten, Sternenstein, Arbeiter-Pausen

Beim Serverstart steht im Log `Deepforge 0.8.3 ready`. Ressourcenpaket unverändert (wie 0.8.1).

## 11 Rechtsklick-Fähigkeiten statt einer
Jede Waffenart hat jetzt mehrere Fähigkeiten. **Jede Waffe behält fest ihre eigene.** Du siehst sie im Beutel und im Tooltip der Waffe („Rechtsklick: …“).

| Waffe | Fähigkeit | Wirkung |
|---|---|---|
| Schwert | **Klingenwirbel** | trifft alles im Umkreis von 4 Blöcken |
| Schwert | **Sturmschnitt** | springt 5 Blöcke vor und schneidet alles auf dem Weg |
| Schwert | **Konterhaltung** | 2 s Parade + Hieb nach vorn |
| Hammer | **Erdbeben** | Schockwelle (5 Blöcke), Gegner werden langsam |
| Hammer | **Schmetterschlag** | gewaltiger Hieb nach vorn (×3) |
| Dolch | **Schattenschritt** | springt hinter den nächsten Gegner, starker Rückenstich |
| Dolch | **Giftklinge** | 6 Sekunden +35 % Schaden auf jeden Treffer |
| Speer | **Durchbohren** | Stoß in einer Linie (8 Blöcke) |
| Speer | **Speerwurf** | weiter Wurf (13 Blöcke), zieht Gegner zu dir |
| Armbrust | **Salve** | Bolzenfächer nach vorn (12 Blöcke) |
| Armbrust | **Explosivbolzen** | Explosion am ersten Ziel (Radius 3) |

**Rarität und Qualität machen die Fähigkeit stärker:**
- **Stärke:** Ungewöhnlich 80 %, selten 100 %, episch 120 %, legendär 140 %, mythisch 160 %, jeweils × Qualität (80–100 %).
- **Episch und besser:** heilt dich um 4 % Leben pro getroffenem Gegner (max. 12 %).
- **Legendär und besser:** 25 % kürzere Abklingzeit.
- **Mythisch:** **Echo-Schlag**. Die Fähigkeit schlägt eine halbe Sekunde später noch einmal mit halber Kraft zu.
- Die Fähigkeiten wirken in Minen und Dungeons. Ausdauerkosten (35) und Ausweichen (Sneak + Rechtsklick) bleiben wie bisher.

## Sternenstein (+12)
- **Nur der Boss im Leerenbruch (Gebiet 7)**, also der stärkste Boss, lässt mit **2 %** einen Sternenstein fallen.
- Anwenden: Gegenstand im Beutel öffnen → **Sternenstein** (Netherstern) mit **Shift-Klick**.
  - **10 %:** der Gegenstand wird sofort **+12** (normal ist bei +10 Schluss).
  - **90 %:** der Gegenstand **zerbricht** und ist weg. Auch aus angelegter Ausrüstung und Sets wird er entfernt.
- Admin-Test: `/df admin sternenstein` gibt 3 Steine.

## Arbeiter brauchen Pausen
- Nach **50 Minuten Arbeit** machen Arbeiter **10 Minuten Pause**, online wie offline. In dieser Zeit liefern sie nichts und bekommen keinen Lohn.
- Das Arbeiter-Menü zeigt „Macht Pause (x Min.)“.
- Zusammen mit der Balance aus 0.8.1 liefert ein Arbeiter damit rund 17 % weniger.
