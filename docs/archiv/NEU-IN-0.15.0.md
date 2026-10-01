# Neu in Deepforge 0.15.0 – Glänzende Monster (Shinys)

Beim Serverstart steht im Log `Deepforge 0.15.0 ready`.

Zum Ressourcenpaket:
- Es gibt ein **neues Ressourcenpaket** mit 2 neuen Icons: Glanzsplitter und Glanzbuch.
- Die SHA-1 steht in `resourcepack/pack.sha1` und ist in `config.yml` schon eingetragen.

## ✧ Glänzende Monster
Ganz selten funkelt ein Minenmonster golden: **1 zu 500** pro Monster. Auch Champions können glänzen.

- **Erkennbar an:**
  - goldenem Leuchten, Funkeln und Namen „✧ Glänzender …“
  - Titel „✧ GLÄNZEND! ✧“ mit Glockenklang
- **Schnell sein:** Es hat doppeltes Leben und **flieht nach 30 Sekunden**. Kurz vorher kommt eine Warnung in der Aktionsleiste, danach „… ist entwischt“.
- **Beute beim Fang:**
  - sicher ein **Gegenstand**: Selten, 25 % Episch, 5 % Legendär („Glanz-…“)
  - Geld im Wert von 60 Erzen der Mine
  - 3 Schattenessenz (für die Alchemie)
  - **Glanzsplitter:** 3 für eine neue Art im Glanzbuch, sonst 1
- **Der ganze Server** bekommt eine Nachricht: „✧ Wanda hat einen Glänzenden … gefangen!“

## 📒 Glanzbuch
**Öffnen:** `/df glanz` oder Museum → **Glanzbuch**.
- 17 Minen × 3 Monsterarten = **51 Einträge**. Gefangene sind mit ✓ markiert, fehlende mit ???.
- **Meilensteine erhöhen die Chance auf glänzende Monster:**

| gefangene Arten | Chance |
|---|---|
| 10 | ×1,5 (1 zu 333) |
| 25 | ×2 (1 zu 250) |
| alle 51 | ×3 (1 zu 167) |

## ✨ Glanzveredelung
- Im **Gegenstand-Menü** (Beutel → Gegenstand, rechts in der Mitte).
- **5 Glanzsplitter:** Der Gegenstand bekommt einmalig **+10 % Schaden, Leben und Rüstung** und ein ✧ vor dem Namen.
- Geht einmal pro Gegenstand, also am besten für die Lieblingsausrüstung.

## 🏆 Rangliste
Neue Tabelle **„Glanzjäger“** mit den meisten gefangenen glänzenden Monstern.

## 📖 Wiki
Die neue Seite **„Glänzende Monster“** erklärt:
- die Chance und die Meilensteine
- die Beute
- die Glanzveredelung

## 🔧 Admin-Testbefehl
`/df admin glanz` lässt direkt vor dir ein glänzendes Monster erscheinen (nur in einer Mine).

## Getestet
- **310 Unit-Tests** grün, 5 neue:
  - Beute und Glanzbuch, neue Art gibt 3 Splitter, Wiederholung 1
  - Chance und Meilensteine
  - Raritätsverteilung (2.000 Fänge simuliert: nie Ungewöhnlich, ~5 % Legendär, ~25 % Episch)
  - Glanzveredelung nur einmal, Kosten, +10 %
  - Wiki und Rangliste
- **Live mit Bot in der Eisenmine:**
  - Ein glänzendes Monster erschien mit Titel und wurde gefangen: „✧ GLANZFANG! – Neu im Glanzbuch · 1/51“, Beute Episch Beinschutz, +720 $, +3 Glanzsplitter.
  - Ein zweites floh nach genau 30 Sekunden: „✧ Glänzender Panzerwächter ist entwischt …“.
  - Das Glanzbuch zeigt „✓ Glänzender Spaltenwerfer“.
  - Die Rangliste zeigt „Glanzjäger: 1. Wanda“.
  - Keine Fehler im Server-Log.
