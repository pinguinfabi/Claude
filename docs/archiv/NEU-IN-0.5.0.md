# Neu in Deepforge 0.5.0

Beim Serverstart steht im Log `Deepforge 0.5.0 ready`. Ressourcenpaket unverändert (wie 0.4.0).

## Zwei neue Dungeons
Im Dungeon-Menü (`/df dungeon`) wählst du unten jetzt zwischen drei Dungeons:

| Dungeon | Freischalten | Besonderheit | Beute |
|---|---|---|---|
| **Runengewölbe** | sofort | der Klassiker | alle Teile |
| **Glutschmiede** | einen beliebigen Dungeon gewinnen | **Glutadern:** unter jedem Spieler (und an ein paar Zufallsstellen) glüht der Boden rot/orange auf, 1,6 s später bricht er aus – rausgehen! | bevorzugt Waffe/Nebenhand, **+15 % Geld**, +25 Schmiedestaub |
| **Frostkrypta** | die Glutschmiede einmal gewinnen | **Eiseskälte:** im Kampf sammelt sich Frost an (Frost-Rand am Bildschirm). Ab 6 wirst du langsam, bei 10 frierst du ein (Schaden). An den **Glutbecken** (2 pro Halle) wärmst du dich auf. | bevorzugt Rüstung, **+1 Lebenssplitter**, +3 Forschungsnotizen |

- Jeder Dungeon hat ein eigenes Aussehen (Netherziegel/Schlacke bzw. Eis/Schnee), eigene Hallennamen und
  **eigene Endbosse** pro Gebiet (z. B. Schlackenkoloss, Reifkoloss) mit einem anderen Angriffsmix.
- In der Party müssen alle den Dungeon freigeschaltet haben.
- Befehl: `/df dungeon start <Schwierigkeit 1-3> <Gebiet 1-7> <Dungeon 1-3>`.
- Admins können zum Testen alles freischalten: `/df admin dungeons`.

## Gebiets-Pfeile im Dungeon-Menü
Die Pfeile „◀ / ▶“ funktionieren wieder und sagen, was los ist: „Das ist bereits das erste Gebiet“ oder
„Gebiet X zuerst im Aufzug freischalten (für alle in der Party)“. Wählbar ist das höchste Gebiet, das
**alle** in der Party freigeschaltet haben.

## Zuschauen im Dungeon
- `/df dungeon zuschauen` (oder das Auge im Dungeon-Menü) – du schaust dem nächsten laufenden Dungeon zu.
  Nochmal ausführen = nächster Dungeon. `/df dungeon zuschauen <Spieler>` = gezielt.
- Du bist im Zuschauermodus, bleibst im Dungeon, siehst die Bossleiste und die Dungeon-Nachrichten
  (mit „[Zuschauer]“). Spieler anklicken = aus ihrer Sicht zuschauen.
- Beenden: `/df dungeon leave` oder `/df home` – du landest wieder dort, wo du vorher warst.
- Die Gruppe sieht „X schaut euch zu“. Zuschauer beeinflussen den Lauf nicht.
- Sicher: Auch nach Absturz/Neustart bekommt man beim nächsten Einloggen seinen alten Spielmodus zurück.

## Admin-Modus & Moderation (Recht `deepforge.admin`, Standard: OP)
`/df admin` öffnet das Moderationsmenü:
- **Alle Online-Spieler** mit Kopf und Kurzinfo (Geld, Gebiet, Dungeonlevel, im Dungeon?).
  Klick auf einen Spieler:
  - **Hinfliegen** (schaltet den Admin-Modus ein) bzw. **Dungeon zuschauen**, wenn er im Dungeon ist
  - **Nach Hause schicken** (Unstuck)
  - **Aus Dungeon & Party entfernen**
  - **Werkzeuge neu ausgeben** (fehlende/kaputte Deepforge-Items)
  - **Geld ± 1.000 / 10.000** (nie unter 0, der Spieler bekommt eine Nachricht)
- **Laufende Dungeons:** wer spielt, Welle, Laufzeit, Zuschauer · Zuschauen · **Lauf beenden** (Shift-Klick,
  ohne Beute – für festgefahrene oder missbrauchte Läufe).
- **Admin-Modus** (`/df admin mode`): Zuschauermodus, überall hinfliegen, auch in fremde Minen. Nochmal = aus,
  zurück an die alte Position.
- Jede Admin-Aktion steht im Server-Log: `[Admin] Name: Aktion -> Spieler`.

## Jagdaufträge: kein Endlos-Geld mehr
Kills sammeln sich nur noch bis **15/15**. Nach dem Abholen startet der Auftrag wieder bei **0**.
Vorher konnte man hunderte Kills „bunkern“ und immer wieder abholen. Alte Stände werden beim Laden auf 15 gekürzt.

## Set-Schmiede
Neu im Abenteuerbuch (Knopf unten rechts), unter **Kampf & Ausrüstung → Set-Schmiede** oder mit `/df setschmiede`:
- **2 doppelte Set-Teile** (gleiches Set, gleicher Platz) + **40 Schmiedestaub** + Geld (1.500 $ × Gebiet)
  → **genau das Set-Teil, das dir fehlt** (z. B. Sturmrufer-Stiefel).
- Getragene und favorisierte Teile werden nie eingeschmolzen, es bleibt immer die stärkste Kopie.
- Das neue Teil übernimmt das höchste Gebiet und die höchste Dungeonstufe der eingeschmolzenen Teile.
- Nebenbei: Set-Teile, die aus einem Waffen- oder Bohrer-Wurf entstanden, haben jetzt richtige Rüstungswerte.

## Funke (Drohne) stärker
- **Geschütz:** Stufe 1: 29 % Schaden alle 1,6 s → Stufe 10: **65 % alle 0,7 s** (vorher 52 % alle 1,2 s).
  Ein voll ausgebautes Geschütz macht jetzt über das Vierfache von Stufe 1.
- **Sammler:** Stufe 10 bringt jetzt wirklich etwas: alle 12 s **5 Erz** (vorher wie Stufe 9).

## Kleinigkeiten
- „Letzte Dungeon-Beute“ im Kampf-Menü wurde vom Verbessern-Knopf verdeckt – jetzt eigener Platz.

## BungeeCord/Waterfall
Neues Proxy-Plugin `proxy/DeepforgeProxy.jar` – siehe `docs/PROXY.md`.
