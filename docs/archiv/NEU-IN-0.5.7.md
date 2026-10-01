# Neu in Deepforge 0.5.7

Beim Serverstart steht im Log `Deepforge 0.5.7 ready`. Ressourcenpaket unverändert (wie 0.5.2).

## Neuer Arbeiter: Holzfäller
- Einstellen in der **Mannschaft** (`/df crew`) → „Holzfäller einstellen“ (gleiche Voraussetzung und Kosten wie
  die anderen Arbeiter: Steinwächter besiegt, freier Platz in der Unterkunft).
- Der Holzfäller fällt Bäume **einer Holzart** und legt die Stämme ins **Holzlager** – online und offline,
  genau wie die anderen Arbeiter.
- **Holzart wählen:** Arbeiter anklicken → „Holzart wechseln“ → Eiche, Birke oder Fichte
  (nur freigeschaltete Sorten; neue Holzfäller starten mit Eiche).
- Leistung wie bei allen Arbeitern: (Stufe + 1) Stämme pro Minute, + Ertrags-Spezialisierung und Forschung.
- **Braucht keinen Brennstoff**, nur Lohn aus dem Betriebsbudget. Lohn wird nur gezahlt, solange er wirklich arbeitet.
- Ist das Holzlager voll, pausiert er („Holzlager voll“) – dann Holz verkaufen oder zu Brettern sägen.
- Alle 90 Arbeitsminuten findet er **1 Harz** (für die Holz-Upgrades).
- Mit Citizens läuft er mit Axt zu einem Baum seiner Holzart im Wald und arbeitet dort.
- Die Offline-Abrechnung zeigt jetzt auch das gefällte Holz.
