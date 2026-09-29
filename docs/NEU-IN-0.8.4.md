# Neu in Deepforge 0.8.4 – Gilden & Stützpunkt

Beim Serverstart steht im Log `Deepforge 0.8.4 ready`. Ressourcenpaket unverändert (wie 0.8.1). Gilden werden in derselben Datenbank gespeichert (neue Tabelle `guilds`, wird automatisch angelegt).

## Gilde gründen & beitreten
- **Gründen:** `/df gilde gründen <Kürzel> <Name>`, z. B. `/df gilde gründen PING Pinguin Minenbund`.
  - Kosten: 25.000 $.
  - Kürzel: 2–4 Zeichen. Name: 3–20 Zeichen. Beides muss eindeutig sein.
- **Einladen:** `/df gilde einladen <Spieler>`. Der Eingeladene bekommt einen **[Annehmen]**-Knopf im Chat oder nutzt `/df gilde annehmen <Kürzel>`.
- **Ränge:**
  - **Anführer:** alles
  - **Offizier:** einladen, entfernen, ausbauen
  - **Mitglied**
- **Ränge verwalten:**
  - `/df gilde befördern <Spieler>`
  - `/df gilde degradieren <Spieler>`
  - `/df gilde entfernen <Spieler>`
- **Verlassen:** `/df gilde verlassen` oder Shift-Klick im Menü.
  - Verlässt der Anführer die Gilde, übernimmt ein Offizier (sonst ein Mitglied).
  - Die letzte Person löst die Gilde auf.
- **Mitglieder:** 5 zum Start, mit der Gildenhalle bis zu 15.

## Gildenchat & Kürzel
- **Gildenchat:** `/df gc <Nachricht>` (nur Mitglieder sehen ihn).
- Das **[KÜRZEL]** steht im normalen Chat hinter dem Namen, in der Tab-Liste und über dem Kopf.

## Gildenkasse & Stützpunkt
- **Einzahlen:** Im Menü mit 1.000 / 10.000 / 100.000 $ oder per `/df gilde einzahlen <Betrag>`. Das Menü zeigt, wie viel du schon eingezahlt hast.
- **Stützpunkt:** 5 Gebäude mit je 5 Stufen. Die Boni gelten **für alle Mitglieder**.

| Gebäude | pro Stufe |
|---|---|
| Kaserne | +2 % Schaden |
| Lazarett | +4 Leben |
| Werkstatt | +3 % Abbautempo |
| Schatzkammer | +2 % Verkaufspreis für Erz und Barren |
| Gildenhalle | +2 Mitgliederplätze |

- **Ausbau:** 20.000 $ × Stufe² aus der Kasse (Stufe 1: 20.000, Stufe 5: 500.000).
- Nur Anführer und Offiziere dürfen ausbauen.
- Jede Stufe braucht das passende **Gildenlevel**.

## Wochenaufträge & Gildenlevel
- Jeden **Montag** gibt es 3 neue Gildenaufträge, zum Beispiel Erz abbauen, Minenmonster oder Champions besiegen, Dungeons gewinnen oder Bäume fällen.
- Das Ziel wächst mit der Mitgliederzahl, und **alle tragen gemeinsam** dazu bei.
- **Belohnung pro Auftrag:** 600 Gilden-XP und 10.000 $ × Mitglieder in die Kasse.
- Gilden-XP heben das Gildenlevel (Level n braucht n × 1.000 XP) und schalten höhere Gebäudestufen frei.

## Menü
- **`/df gilde`** oder Hauptmenü → **Gilde** (Banner).
- Das Menü zeigt:
  - Gildenlevel, XP, Kasse
  - alle Mitglieder mit Rang und Online-Status
  - die 5 Gebäude
  - die 3 Wochenaufträge mit Fortschritt
  - Knöpfe zum Einzahlen
- Ohne Gilde zeigt das Menü, wie man gründet, und offene Einladungen.
