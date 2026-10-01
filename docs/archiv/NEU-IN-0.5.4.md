# Neu in Deepforge 0.5.4

Beim Serverstart steht im Log `Deepforge 0.5.4 ready`. Ressourcenpaket unverändert (wie 0.5.2).

## Krit neu schmieden: 3 günstige Versuche, dann extrem teuer
Gilt pro Gegenstand, getrennt für **Krit-Chance** und **Krit-Schaden**:

| Versuch | Geld (Gebiet 1) | Staub |
|---|---|---|
| 1. | 500 $ | 5 |
| 2. | 1.500 $ | 10 |
| 3. | 4.500 $ | 20 |
| 4. | **1.000.000 $** | 500 |
| 5. | **10.000.000 $** | 1.000 |
| danach | jeweils ×10 | ×2 |

- In tieferen Gebieten wird alles mit (Gebiet) multipliziert, z. B. Gebiet 3: 1.500 / 4.500 / 13.500 $, dann 3.000.000 $.
- Im Gegenstand-Menü steht beim Knopf der aktuelle Preis und wie viele günstige Versuche noch übrig sind.
- Nach dem Schmieden steht im Chat der Preis für das nächste Mal. Beim dritten Mal kommt der Hinweis,
  dass es der letzte günstige Versuch war.
- Schon vorhandene Gegenstände starten bei Versuch 1 (frühere Neuschmiedungen wurden nicht mitgezählt).
