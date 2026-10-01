# Neu in Deepforge 0.8.1 – Meisterschaft, Arbeiter-Balance, neue HUD-Position

Beim Serverstart steht im Log `Deepforge 0.8.1 ready`.
**Neues Ressourcenpaket** (SHA-1 `fde5a3848990bb52d209867cc13bc04030ba567f`) für die neue HUD-Position. Mit Self-Host oder leerem `sha1` passiert das automatisch. Sonst die neue ZIP hochladen und den SHA-1 in der `config.yml` eintragen.

## Meisterschaft & Talente (getrennt vom Tiefenpass)
- **Eigene, dauerhafte Meisterschafts-XP.** Es gibt keine Saison, nichts wird zurückgesetzt. XP gibt es für alles, was auch Tiefenpass-XP gibt (Erz, Monster, Champions, Rätsel, Dungeons, Tagesaufgaben …), sie wird aber getrennt gezählt.
- **Jede Meisterschaftsstufe gibt 1 Talentpunkt.** Maximal gibt es Stufe 39, dann ist alles verteilt.
- Menü: **`/df talente`** oder Charakter → **Meisterschaft**. Bei einem Stufenaufstieg gibt es einen Titel und einen Hinweis im Chat.

| Baum | Talente (je 3 Ränge) | ★ Schlüsseltalent (ab 8 Punkten im Baum) |
|---|---|---|
| **Krieger** | Klingenkunst +3 % Schaden · Zähigkeit +5 Leben · Bollwerk −3 % erlittener Schaden · Kombo-Meister: Kombo-Fenster +0,3 s | **Blutrausch:** jeder 10. Kombo-Treffer ist ein sicherer Krit |
| **Bergmann** | Bohrmeister +4 % Abbautempo · Kühlsystem −6 % Hitze · Adernsucher +5 % Doppel-Erz · Runengespür +1 % Runenfund | **Erzflut:** 5 % Chance, dass ein Erzblock dreifach gibt |
| **Unternehmer** | Handelsgeschick +3 % Verkaufspreis · Sparfuchs −4 % Upgrade-Kosten · Holzkenner +5 % Doppel-Holz · Wertschöpfer +15 % Staub beim Zerlegen | **Magnat:** +10 % auf jeden Erz- und Barrenverkauf |

- **Zurücksetzen:** 1.000 $ pro verteiltem Punkt. Danach sind alle Punkte wieder frei.

## Arbeiter-Balance (sie waren viel zu stark)
**Warum:** Ein ausgebauter Arbeiter lieferte bis zu 10 Waren pro Minute, im Leerenbruch also über 300.000 $ pro Stunde. Der Lohn war dabei fest (2–7 $/Min.), egal in welchem Gebiet. Dazu kamen bis zu 24 Stunden Offline-Arbeit.

| | vorher | jetzt |
|---|---|---|
| Waren pro Minute (Stufe 1) | 2 | **0,5** |
| Waren pro Minute (Stufe 5 + Spezialisierung + Forschung) | bis 10 | **etwa 2,3–3,5** |
| Spezialisierung „Leistung“ | +1 / Min. | +0,4 / Min. |
| Forschung „Arbeiterschulung“ | +1 / Min. pro Stufe | +0,25 / Min. pro Stufe |
| Lohn | fest 2–7 $ pro Minute | Grundlohn 2–7 $ **plus 20 % vom Warenwert** (Händler 10 %, Spezialisierung „Sparsam“: 25 % weniger Anteil) |
| Offline-Arbeit | 8 h (+2 h pro Lagerstufe), max. 24 h | **6 h** (+1 h pro Lagerstufe, +1 h pro Logistik-Forschung), **max. 12 h** |

- Arbeiter arbeiten jetzt in Bruchteilen: Eine halbe Ware pro Minute ergibt jede zweite Minute eine Lieferung. Lohn wird nur für echte Lieferungen bezahlt.
- Kann eine Ware nicht abgeliefert werden (Lager voll, Budget leer), fällt sie weg.
- Die Arbeiter-Menüs zeigen die neuen Werte (Waren/Min. mit Nachkommastellen, Lohnanteil).

## HUD tiefer, Hinweise darüber
- Die Spiel-HUD (Leben, Geld, Rucksack, Hitze bzw. im Kampf Leben, Ausdauer, Fähigkeit, Kombo) sitzt jetzt **weiter unten**, dort wo früher die Herzen waren.
- **Hinweise** („Besiegt · +…“, Champion, Rucksack fast voll …) erscheinen **darüber**. Die HUD bleibt dabei stehen und verschwindet nicht mehr.
- Ohne Ressourcenpaket (Text-HUD) bleibt alles wie bisher.
