# Neu in Deepforge 0.2.0

Beim Serverstart steht im Log `Deepforge 0.2.0 ready`. Steht dort `0.1.0`, läuft noch die alte Jar.

## Kampf und Ausrüstung
- Waffen haben keinen versteckten Tempo-Malus mehr; alle Waffenarten starten beim gleichen Tempo. Nur Tempo-Werte auf der Ausrüstung erhöhen den Trefferschaden.
- Krit-Reroll (5 Schmiedestaub + Geld) funktioniert auf jeder Java-Installation. Bereich nach Seltenheit und Qualität: Ungewöhnlich 1–6 %, Selten 2–8 %, Episch 3–10 %, Legendär 4–12 %, Mythisch 5–15 %. Ein Titel zeigt alt → neu und die gesamte Krit-Chance.
- Dolche haben einen Rückenbonus bei Treffern von hinten: Ungewöhnlich +20 %, Selten +35 %, Episch +50 %, Legendär +65 %, Mythisch +75 %. Andere Waffenarten haben keinen Rückenbonus.
- Fehlgeschlagene Menüaktionen (fehlendes Geld, Staub, Unterlagen …) zeigen einen roten Titel mit dem Grund.

## Spielerwerte (`/df stats`)
Vier Bereiche mit den Werten, die das Spiel tatsächlich verwendet: Kampf, Bergbau, Ressourcen (inklusive Schmiedestaub, Relikte, Unterlagen, Fragmente) und Fortschritt. Schmiedestaub steht außerdem in der Seitenleiste und im Beutebeutel.

## Meilensteine (`/df milestones`)
Neun Ziele mit je drei Stufen: Bergmann, Monsterjäger, Bossbezwinger, Holzfäller, Schmelzmeister, Marktprofi, Gewölbegänger, Unternehmer, Forscher. Belohnungen: Stufe 1 1.000 $ + 3 Staub + 1 Unterlage, Stufe 2 8.000 $ + 8 Staub + 1 Relikt + 3 Unterlagen, Stufe 3 40.000 $ + 20 Staub + 3 Relikte + 8 Unterlagen.

## Arbeiter
- Laufen nicht mehr fest; wechseln zu einer anderen Ader, wenn ihre abgebaut wurde.
- Funde nach Arbeitsminuten: Bergarbeiter alle 45 Min. 1 Staub und alle 4 Std. 1 Relikt, Schmelzer stündlich 1 Unterlage, Händler stündlich einen Handelsbonus.
- Mannschaft zeigt Waren/Minute, Warenwert pro Stunde, Lohn und den nächsten Fund.
- Händler behalten die Eisenbarren für die nächste Forschung und den offenen Barrenauftrag.

## Wirtschaft, Holz, Welt
- Schmelzen: Erzart selbst wählen („Bis 32“ oder „Alles“). „Nur Erze verkaufen“ behält die Barren.
- Forschung zeigt den aktuellen Gesamteffekt.
- Holzfäller-Gebiet: 36 statt 12 fällbare Bäume. Bestehende Wälder werden einmalig neu aufgebaut.
- Gemeinsame Welt, persönliche Gegner und Bosse: siehe `GEMEINSAME-WELT.md`.
