# Neu in Deepforge 0.3.3

Beim Serverstart steht im Log `Deepforge 0.3.3 ready`. Ressourcenpaket unverändert (wie 0.3.0–0.3.2).

## Keine lila-schwarzen Kästchen ohne Ressourcenpaket
- Wer das Deepforge-Paket nicht aktiv hat, bekommt Bohrer, Klinge, Handbuch, Axt, Heilkristall und alle Menü-Knöpfe
  als **normale Minecraft-Gegenstände** (Spitzhacke, Schwert, Kompass …) statt der fehlenden Textur.
- Sobald das Paket geladen ist (vom Server geschickt oder `/df pack local`), werden Hotbar und Menüs sofort auf die
  Deepforge-Modelle umgestellt.
- Hinweis: Dekorationen in der Welt (Trophäen, Fundkisten, Werkstatt-Bohrer) brauchen weiterhin das Paket.

## Seitenleiste
- Der Titel zeigt wieder **„Pinguin Netzwerk“** (ohne „· Deepforge“); die Zeile „DEIN FORTSCHRITT“ bleibt entfernt.

## Ressourcenpaket aktivieren (Kurzfassung)
In Minecraft *Optionen → Ressourcenpakete*: `Deepforge-ResourcePack.zip` (liegt auch auf dem Server unter
`plugins/Deepforge/`) in die rechte Liste „Ausgewählt“ ziehen und **ganz nach oben** schieben, dann im Spiel `/df pack local`.
