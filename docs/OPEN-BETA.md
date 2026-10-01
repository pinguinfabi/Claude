# Deepforge – Open Beta: alles auf einen Blick

Dieser Überblick ist für dich und dein Team, z. B. für Ankündigungen, Support und Tests. Details zu jeder Version stehen in den `NEU-IN-x.md`-Dateien, ältere im Ordner `archiv/`. Im Spiel erklärt das Wiki alles mit den echten Zahlen: `/df wiki`.

## Spielablauf
1. **Einstieg:** Spieler landen automatisch im Dorf und bekommen Handbuch und Grundwerkzeug. Der Vorarbeiter führt durch 12 Lernziele (`/df tutorial`).
2. **Minen:** 17 Minen, von der Eisenmine bis zum Weltenkern. Jede hat:
   - eigenes Erz
   - eigene Höhlenform
   - Monster
   - einen Gebietsboss
   - ab Mine 3 teils Gefahren wie Sporenluft, Grubenwasser, Gift oder Schatten

   Die nächste Mine öffnet sich nach Bosssieg, Bohrerstufe und Freischaltpreis.
3. **Geld verdienen:** Erz abbauen, verkaufen oder zu Barren schmelzen, dazu Aufträge, Tagesaufträge, Jagdaufträge und Arbeiter (auch offline).
4. **Kampf:**
   - 5 Waffenarten mit Rechtsklick-Fähigkeit, Ausweichrolle, Haltung brechen, Kombos
   - Champions und glänzende Monster
   - 5 Monsterarten
   - Gebietsbosse mit 3 Phasen und 10 Angriffen
5. **Dungeons:** 3 Arten (Runengewölbe, Glutschmiede, Frostkrypta), zufällig gebaut, mit Rätseln, Wächtern und Endboss.
   - Normal / Veteran / Albtraum, Level pro Mine
   - Partys bis 4 Spieler
   - Tiefengang als Endlos-Modus
6. **Ausrüstung:**
   - Beute von gewöhnlich bis mythisch, Verbessern bis +10
   - Runen und Sockel, Set-Schmiede, Ausrüstungs-Sets
   - Sternenstein (+11) und Urboss
   - **Relikt-Schmiede:** 6 Waffen nur aus seltenen Boss-Teilen
7. **Langzeit:**
   - Tiefenpass und Meisterschaft (Talente)
   - Alchemie, Archäologie & Museum, Glanzbuch, Begleiter aus Eiern, Drohne „Funke“
   - Gilden mit Stützpunkt und Farbe
   - Prestige
8. **Holzwald:** 3 Haine (Eiche, Birke, Fichte) mit Sägewerk, Holzfällern und Waldmonstern. Die Haine sind nach Forststufe gesperrt.

## Wichtige Befehle für Spieler
| Befehl | Wofür |
|---|---|
| `/df menu` (oder Rechtsklick auf das Handbuch) | Hauptmenü |
| `/df wiki` | Wiki mit allen Zahlen |
| `/df tutorial` | Lernziele |
| `/df home` | zurück ins Dorf |
| `/df stats` · `/df loot` · `/df sets` | Charakter, Beute, Ausrüstungs-Sets |
| `/df dungeon` · `/df party` | Dungeons und Party (im Netzwerk: `/party`) |
| `/df relikte` · `/df runen` · `/df talente` · `/df pass` | Relikt-Schmiede, Runen, Meisterschaft, Tiefenpass |
| `/df gilde` · `/df gc <Text>` | Gilde und Gildenchat |
| `/df daily` · `/df milestones` · `/df top` | Tagesaufträge, Meilensteine, Rangliste |
| `/df pack` | Ressourcenpaket erneut laden |

## Admin-Befehle (Recht `deepforge.admin`, Standard: OP)
| Befehl | Wofür |
|---|---|
| `/df admin` | Moderationsmenü |
| `/df admin modus` | Admin-Modus an/aus |
| `/df admin money <Betrag>` | Testgeld |
| `/df admin gebiet <1–17>` | bis zu dieser Mine freischalten und hinreisen |
| `/df admin gott` | unverwundbar an/aus |
| `/df admin event <Goldrausch\|Erzrausch\|Monsterflut\|…\|stop> [Minuten]` | Weltereignis starten oder stoppen |
| `/df admin monster <0–4>` | Monsterart neben dir erschaffen |
| `/df admin champion` · `glanz` | Champion oder glänzendes Monster erschaffen |
| `/df admin bosskampf <0–2>` · `bossphase <2\|3>` | Gebietsboss starten, Phase springen |
| `/df admin urboss [jetzt]` | Urboss nach dem nächsten Albtraum-Sieg, oder sofort |
| `/df admin dungeons` | alle Dungeon-Arten freischalten |
| `/df admin boss` · `skip` · `phase <n>` · `guard <Name>` | Dungeon-Tests: Endboss, Welle überspringen, Bossphase, Wächter |
| `/df admin sternenstein` · `runen` · `ei <Rarität>` · `brut` · `passxp <n>` | Test-Gegenstände und -Fortschritt |

Testbefehle verändern den Spielstand des Admins. Am besten nur auf einem Testprofil benutzen.

## Balance (Stand 0.22.0)
- **Preise wachsen mit dem Erzpreis der eigenen Mine.** So kostet ein Kauf in jeder Mine ungefähr gleich viel Spielzeit. Die ersten Minen bleiben günstig, damit der Einstieg schnell geht.
- **Freischaltung:** Mine 2 kostet 3.000 $, Mine 8 kostet 6 Mio. $, der Weltenkern 7,2 Mrd. $. Dazu kommen Bohrerstufe und Bosssieg.
- **Bohrer, Klinge, Schutz:** ab Stufe 10 jede Stufe mindestens ×1,6 teurer.
- **Dungeons:**
  - Das Leben wächst mit der Mine wie bei den Minenmonstern.
  - Veteran: Leben ×1,8, Schaden ×1,5.
  - Albtraum: Leben ×2,8, Schaden ×2,1.

Feedback aus der Beta (zu schnell, zu langsam, zu leicht) am besten mit Minennummer und Spielzeit melden. Dann lässt sich die passende Stelle gezielt anpassen.
