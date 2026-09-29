# Neu in Deepforge 0.12.0 – Prestige & Tiefenglut

Beim Serverstart steht im Log `Deepforge 0.12.0 ready`.

Zum Ressourcenpaket:
- Es gibt ein **neues Ressourcenpaket** mit 6 neuen Icons: den Prestige-Stern und die 5 Glut-Talente.
- Die SHA-1 steht in `resourcepack/pack.sha1` und ist in `config.yml` schon eingetragen.

## ★ Prestige – noch einmal von vorn, aber härter
Wer den **Boss im Weltenkern** (Gebiet 17) besiegt hat, kann Prestige machen:
- **Hauptmenü → Stern oben** (neben dem Weltereignis) oder `/df prestige`
- Bestätigen mit **SHIFT + Klick**, damit es nicht aus Versehen passiert
- nur außerhalb von Kampf und Dungeon

| Wird zurückgesetzt | Bleibt |
|---|---|
| Gebiet → Eisenmine | **alle Ausrüstung** (inkl. Stufen, Sockel, Sternenstein) |
| Geld → Startgeld (250 $ oder mehr mit Glutkapital) | Runen, Sternensteine, Schmiedestaub |
| Bohrer, Klinge, Schutz, Erzglück, Rucksack, Lager | Begleiter, Eier, Funke |
| Erz, Barren, Betriebsbudget | Meisterschaft & Talente, Tiefenpass |
| besiegte Gebietsbosse (müssen neu besiegt werden) | Dungeon-Level, Gilde, Wald & Holz |
| | Unterkunft, Schmelze, Heiltasche, Forschung |
| | Arbeiter (ziehen mit in die Eisenmine) |

### Was sich pro Prestige ändert
| | pro Prestige | Prestige 1 | Prestige 5 | Prestige 10 |
|---|---|---|---|---|
| Leben aller Gegner | ×1,35 | ×1,35 | ×4,48 | ×20,1 |
| Schaden aller Gegner | ×1,25 | ×1,25 | ×3,05 | ×9,31 |
| Werte neuer Beute | ×1,15 | ×1,15 | ×2,01 | ×4,05 |
| Erz- und Barrenwert | +25 % | +25 % | +125 % | +250 % |

- **Gilt überall:** Minenmonster, Champions, Gebietsbosse, Dungeons (inkl. Wächter und Endboss) und Tiefengang.
- **Beute:** Jedes Teil merkt sich, in welchem Prestige es gefunden wurde. Alte Ausrüstung behält ihre Werte, neue ist um ×1,15 pro Prestige stärker. Das gilt für alle Quellen: Bosse, Dungeons, Gewölbekisten, Wächtertruhen, Herstellung.
- **Keine Obergrenze, aber eine weiche Wand:** Gegner wachsen schneller als die Beute. Bei Prestige 10 haben sie 5× so viel Leben pro Beute-Stärke. Irgendwann schafft man die Bosse einfach nicht mehr. Wie weit kommst du?
- **Dungeons in der Gruppe:** Es zählt das **höchste Prestige der Gruppe**. Mitspieler ohne Prestige machen es also nicht leichter.

## 🔥 Tiefenglut – der Prestige-Talentbaum
- Pro Prestige gibt es **1 Tiefenglut**, bei jedem 5. Prestige **2**.
- Ausgeben im Prestige-Menü (untere Reihe). Jedes Talent geht bis Rang 5.

| Talent | pro Rang |
|---|---|
| **Glutader** | +10 % Erz- und Barrenwert (gilt auch für Händler-Arbeiter) |
| **Glutklinge** | +6 % Schaden |
| **Glutpanzer** | +6 % Leben |
| **Glutbohrer** | +10 % Abbaukraft |
| **Glutkapital** | Startgeld nach dem Prestige: 5.000 $, 20.000 $, 80.000 $, 320.000 $, 1,28 Mio. $ |

## ★ Sterne im Namen & Rangliste
- **Anzeige:** ★1 bis ★9, ab Prestige 10 ✪10, in Gold:
  - im **Chat** (hinter dem Namen)
  - über dem **Kopf**
  - in der **Tabliste**
- **Wenn jemand Prestige macht**, bekommt der ganze Server eine Nachricht.
- **Rangliste:** neue Tabelle **„Prestige“** (Hauptmenü → Rangliste).

## 📖 Wiki
Die neue Seite **„Prestige & Tiefenglut“** erklärt alles:
- was bleibt und was zurückgesetzt wird
- alle Faktoren mit Beispielen für Prestige 5 und 10
- die Regel für Gruppen
- alle 5 Glut-Talente

Der Hilfe-Knopf im Prestige-Menü öffnet diese Seite direkt.

## Getestet
- **294 Unit-Tests** grün, 7 neue für Prestige:
  - Freischaltung nur nach dem letzten Boss
  - Reset und was bleibt
  - neue Beute stärker, alte unverändert
  - weiche Wand (Gegner wachsen schneller als Beute)
  - Glut-Talente und Startgeld
  - Verkaufspreis mit Prestige
  - Sterne, Wiki, Rangliste
- **Live mit Bot:**
  - Hauptmenü zeigt „BEREIT!“.
  - Das Prestige-Menü zeigt alle Werte.
  - Ein normaler Klick wird abgelehnt, SHIFT + Klick löst Prestige 1 aus (Titel und Nachricht).
  - Danach ist das Menü gesperrt: „Schalte den Weltenkern frei (Gebiet 1/17)“.
  - Das Talent „Glutader“ wurde gelernt, der Erzwert steigt von ×1,25 auf ×1,38.
  - Der Chat zeigt „ADMIN Wanda ★1 » …“.
  - Keine Fehler im Server-Log.
