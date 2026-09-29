# Neu in Deepforge 0.15.4 – Dungeon-Level: sichtbar machen, was ein Level bringt

Beim Serverstart steht im Log `Deepforge 0.15.4 ready`. **Das Ressourcenpaket bleibt gleich.**

## Die Frage: „Warum Level 5 spielen, wenn Mythisch gleich ist wie bei Level 1?“
Die Chancen bleiben **bewusst langsam**. Die besten Waffen sind ein Grind, das ist so gewollt. Bisher stand aber nirgends, was ein höheres Level überhaupt bringt. Das zeigt jetzt jeder Schwierigkeits-Knopf im Dungeon-Menü:

- **Chancen auf diesem Level:** Mythisch · Legendär · Episch
- **Beutestärke und Geld auf diesem Level**, z. B. „Beutestärke ×1,24 · Geld ×1,48 (Level 5)“
- **Pro Level:** Beute +6 % stärker (ab Level 31: +2 %) · Geld +12 %
- **Pro Level:** Legendär +0,2 % · Episch +0,4 % · Mythisch +0,1 % alle 4 Level
- **Das nächste Level:** z. B. „Level 5: Mythisch 0,6 % · Legendär 6,3 %“
- **Wann Mythisch wieder steigt:** z. B. „Mythisch steigt wieder ab Level 9“
- **Vergleich zu Level 1:** z. B. „Gegenüber Level 1: Mythisch ×1,2 · Legendär ×1,2“

Der wichtigste Grund für höhere Level ist also die **Beutestärke**: Ein Legendär von Level 10 hat ×1,54 die Werte eines Legendärs von Level 1, eines von Level 30 sogar ×2,74. Die Rarität steigt nur langsam mit.

## 📖 Wiki
Unter Dungeons gibt es den neuen Eintrag **„Was ein Level mehr bringt“** mit Beispielen: Normal Level 1 → 10 → 30 → 50 ergibt Mythisch 0,5 → 0,7 → 1,2 → 1,7 % und Beute ×1,5 / ×2,7 / ×3,2.

## Behoben
- Bei extrem hohen Dungeon-Levels konnte die Chancen-Berechnung überlaufen. Jetzt wird dort mit größeren Zahlen gerechnet.

## Getestet
- **316 Unit-Tests** grün, neu: Die Texte „pro Level“, „nächstes Level“ und „Mythisch steigt wieder ab …“ stimmen mit den echten Regeln überein.
