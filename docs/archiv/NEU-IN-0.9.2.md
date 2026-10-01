# Neu in Deepforge 0.9.2 – Siegeshalle: Kamerafahrt, Statistik, Kisten, selbst gehen

Beim Serverstart steht im Log `Deepforge 0.9.2 ready`. Ressourcenpaket unverändert (wie 0.9.0).

## Nach dem Dungeon-Sieg: die Siegeshalle
Bisher wurde man nach dem Sieg sofort ins Dorf teleportiert. Jetzt bleibt die Gruppe in der Bosshalle.

### 1. Kamerafahrt (8 Sekunden)
- Die Kamera fliegt in einem Halbkreis langsam steigend um die Bosshalle, mit Feuerwerk und Funken.
- Nacheinander erscheinen große Titel:
  1. **SIEG!** mit Dungeon, Level und Zeit
  2. **★ MVP ★:** wer den meisten Schaden gemacht hat, mit Schaden und Anteil an der Gruppe. Solo: dein Schaden, deine Gegner, deine beste Kombo.
  3. **Deine Auszeichnung**, z. B. „Bossbrecher“, oder „Gut gekämpft!“ mit deinen Zahlen
- Die Kamerafahrt nutzt kurz den Zuschauermodus. Wer dabei das Spiel verlässt, bekommt beim nächsten Einloggen automatisch seinen normalen Modus zurück.

### 2. Statistik im Chat
```
━━━━━━ ABSCHLUSS · Runengewölbe L12 ━━━━━━
Zeit 6:42 · 3 Spieler · Gesamtschaden 1,2 Mio.
#1 Anna · 612.400 Schaden (51 %) · Boss 301.200 · 48 Kills · 131 Krits · Kombo 64
     eingesteckt 4.310 · geheilt 820 · 0× K.O.
#2 …
★ Schadenskönig: Anna – 612.400 Schaden · 51 %
★ Schlächter: Ben – 57 Gegner besiegt
★ Fels in der Brandung: Cem – 9.870 Schaden eingesteckt
```

Pro Spieler werden gezählt:
- Schaden gesamt und am Boss
- Kills, Krits, beste Kombo
- eingesteckter Schaden (nach Rüstung)
- geheiltes Leben, K.O.s

| Auszeichnung | für |
|---|---|
| Schadenskönig | den meisten Schaden |
| Schlächter | die meisten besiegten Gegner |
| Bossbrecher | den meisten Schaden am Boss |
| Kombo-Meister | die längste Kombo |
| Zäh wie Leder | das meiste geheilte Leben |
| Fels in der Brandung | den meisten eingesteckten Schaden (nur in Gruppen) |

### 3. Gewölbekisten direkt kaufen
- In der Halle stehen **3 Gewölbekisten**. **Rechtsklick** kauft die nächste Kiste für dich, mit Totem-Effekt und Sound.
- Jeder Spieler kann bis zu **3 Kisten** pro Sieg kaufen. Der Preis verdoppelt sich jedes Mal: 2×, 4×, 8× der Dungeon-Münzen.
- `/df reward` funktioniert weiterhin.
- Gewölbekisten nutzen jetzt dieselbe gedeckelte Beute-Stärke wie der Dungeon selbst: +6 % pro Level bis Level 31, danach +2 %. Vorher waren es ungedeckelt +7,5 % pro Level.

### 4. Selbst entscheiden, wann du gehst
- **Ausgang:** Rechtsklick auf den **Seelenanker** (lila Portal-Funken) oder `/df dungeon leave`. Das ist ohne Nachteil, die Beute ist längst im Beutel.
- Zu Hause öffnet sich automatisch das Beute-Fenster mit allen neuen Teilen.
- Die Halle schließt nach **3 Minuten**. Wer dann noch drin ist, kommt ins Dorf. Die Bossleiste zeigt die Restzeit.
- Beim Serverneustart und wenn ein Admin den Lauf schließt, wird die Halle einfach geschlossen. Die Belohnungen sind schon ausgezahlt.
