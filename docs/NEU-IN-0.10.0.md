# Neu in Deepforge 0.10.0 – Wiki-Fenster, neue Menüführung, Dungeon-Balance, Boss-Fix

Beim Serverstart steht im Log `Deepforge 0.10.0 ready`.

**Neues Ressourcenpaket** (SHA-1 siehe `resourcepack/pack.sha1`, in `config.yml` schon eingetragen) mit dem Wiki-Icon. Mit Self-Host oder leerem `sha1` passiert das automatisch.

## 🐞 Behoben: Bosse in Gebiet 8–17
- **Fehler:** Die Bosse der neuen Minen haben ihre Angriffsmuster nicht gefunden (`Index 7 out of bounds` im Log). Dadurch sind sie hängen geblieben und haben den Server-Log geflutet.
- **Jetzt:** Alle 17 Bosse greifen normal an. Die Bosse der tiefen Minen nutzen die sieben bekannten Angriffsmuster reihum.

## 📖 Das Wiki – als echtes Fenster
- **Öffnen:**
  - `/df wiki` (oder `/df hilfe`)
  - Hauptmenü → **WIKI** (Buch oben links)
  - **Hilfe-Buch unten rechts in jedem Menü**. Es öffnet direkt die passende Seite, z. B. im Runenbeutel die Runen-Seite.
- **Darstellung:** Es ist ein Dialog-Fenster (Minecraft 1.21.8), kein Chat und kein NPC-Gespräch.
  - Jeder Eintrag hat sein **Icon** aus dem Ressourcenpaket: Erze, Monster, Runen, Eier, Begleiter, Gebäude …
  - Unten sind Knöpfe zu den Unterseiten, **◀ Zurück** und **⌂ Wiki-Start**.
  - Das Fenster lässt sich mit Esc schließen, das Spiel läuft weiter.
- **Alle Zahlen kommen direkt aus den Spielregeln.** Ändert sich die Balance, stimmt das Wiki automatisch.
- **Themen (19):**
  - Erste Schritte
  - Minen & Gebiete, mit **17 Unterseiten**. Jede Mine hat Erz, Preise, Bohrerstufe, Freischaltkosten, Monsterleben und -schaden, Bossleben auf allen drei Schwierigkeiten, Gefahren, Hitze und ihren benannten Gegenstand.
  - Bergbau & Bohrer
  - Kampf & Werte: Krit, Rüstung, Leben, Kombo, alle 11 Waffenfähigkeiten
  - Ausrüstung & Beute: Raritäten, Boss- und Dungeon-Chancen, Aufwerten, Neuschmieden, Sets, Beutel
  - Runen: alle 6 Arten mit Werten, Fundchancen, Sockel
  - Sternenstein & Urboss
  - Dungeons: alle 3 Arten, Level, Belohnungen, Siegeshalle, Rätsel
  - Tiefengang
  - Bosse & Champions
  - Begleiter & Eier: alle Chancen, Raritäten, Brutzeiten, alle 7 Arten mit Min- und Max-Bonus
  - Meisterschaft & Talente (alle 15 Talente)
  - Tiefenpass, Aufträge & Ziele (alle XP-Werte)
  - Arbeiter & Betrieb
  - Wald & Holz
  - Gilden
  - Upgrades & Kosten
  - Weltereignisse
  - Befehle

## 🧭 Menüs übersichtlicher
- **„Zurück“ geht jetzt wirklich ins letzte Menü.**
  - Das Spiel merkt sich den Weg, z. B. Hauptmenü → Kampf → Beutebuch → Zurück = Kampf → Zurück = Hauptmenü.
  - Der Knopf zeigt, wohin er führt.
  - Menüs, die du per Befehl, Station oder NPC öffnest, starten einen neuen Weg.
- **Neues Hauptmenü**, nach Themen in Reihen sortiert:

| Reihe | Knöpfe |
|---|---|
| oben | 📖 Wiki · Geld/Relikte · Weltereignis |
| Arbeiten | Bergbau · Wald & Sägewerk · Arbeiter & Betrieb · Aufträge & Abenteuer |
| Kämpfen | Kampf & Ausrüstung · **Dungeons** (neu, direkt) · Tiefengang · Runen |
| Fortschritt | Nächstes Ziel · Tiefenpass · Tagesaufträge · **Rangliste** (neu) |
| Gemeinschaft | Gilde · Begleiter & Brutstätte · Funke · Heilen |
| unten | Zum Dorf · Tutorial · Schließen · Hilfe & Wiki |

## 🎯 Krit-Chance: was es mit „max 16“ auf sich hat
- **Die Obergrenze liegt bei 60 %, das ist auch weiterhin so.** Was du beim „Krit neu schmieden“ gesehen hast, war nur der Bereich **pro Gegenstand**: je nach Rarität bis etwa 15 % (mythisch), mal Qualität.
- Die Krit-Chance **aller** angelegten Teile wird addiert, dazu Grundwert 5 %, Glücksrunen, Frostling und Talent. Das Ganze ist bei 60 % gedeckelt, der Überschuss wird zu Krit-Schaden (max. +100 %).
- **Neu:** Ausrüstung aus dem Tiefen Schacht würfelt höher, +4 % des Bereichs pro tiefem Gebiet. Ein mythisches Teil aus dem Weltenkern schafft bis zu **21 %**.
- Das Schmiede-Menü zeigt jetzt „pro Teil“, die 60-%-Obergrenze und deine aktuelle Gesamt-Krit-Chance. Die Charakterseite zeigt die Obergrenze ebenfalls.

## ⚖ Dungeon-Balance-Check
### Was ich geprüft habe
- **Gegner:** +10 % Leben und +2,5 % Schaden pro Dungeon-Level, dazu 3 Schwierigkeiten (+55 % Leben je Stufe).
- **Beute:** +6 % Stärke pro Level bis Level 31, danach +2 %.

  | | Normal L1 | Albtraum L30 |
  |---|---|---|
  | Episch oder besser | 30 % | 62 % |
  | Legendär oder besser | 5,5 % | 18 % |
  | Mythisch | 0,5 % | 2,2 % |

- **Ergebnis:**
  - Die Beute-Kurve ist fair.
  - **Problem 1:** Jeder Sieg hat dein Dungeon-Level fest um 1 erhöht, ohne Weg zurück. Irgendwann war ein Gebiet zu schwer und damit tot. Grindig und frustrierend.
  - **Problem 2:** Das Dungeon-Geld ist in den tiefen Gebieten weit hinter dem Bergbau zurückgefallen. Leerenbruch: 3.300 $ pro Sieg gegen 1,35 Mio. $ pro Stunde Bergbau.

### Was jetzt anders ist
1. **Level frei wählbar.** Im Dungeon-Menü stehen neben den Schwierigkeiten ◀ und ▶ (Shift: ±5).
   - Du spielst jedes Level von 1 bis zu deinem Höchstlevel.
   - Niedrigere Level sind leichter und geben weniger Beute.
   - **Dein Level steigt nur bei einem Sieg auf deinem Höchstlevel.** Du kannst also nie „feststecken“.
2. **Dungeon-Geld folgt dem Erzpreis des Gebiets:** etwa 90 Erze pro Sieg, mal Schwierigkeit, +12 % pro Level.

   | Gebiet | normal | Albtraum | zum Vergleich: 10 Min. Bergbau |
   |---|---|---|---|
   | 1 Eisenmine | 1.080 $ | 3.240 $ | ~4.400 $ |
   | 4 Versunkene Schächte | 9.000 $ | 27.000 $ | ~37.000 $ |
   | 7 Leerenbruch | 54.000 $ | 162.000 $ | ~222.000 $ |
   | 10 Giftschlund | 265.500 $ | 796.500 $ | ~1,1 Mio. $ |
   | 17 Weltenkern | 10,9 Mio. $ | 32,6 Mio. $ | ~44,7 Mio. $ |

   Damit lohnt sich ein Dungeon neben der Ausrüstung auch beim Geld. Bergbau bleibt der sichere Geldweg, Dungeons sind der Weg zu Ausrüstung.
   - Gewölbekisten (2×, 4×, 8× Dungeon-Geld) und die Tiefengang-Belohnungen wachsen mit.
3. **Tagesbonus gegen Grind:** Der **erste Dungeon-Sieg jedes Tages** zahlt das Geld doppelt und +30 Schmiedestaub.
