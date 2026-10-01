# Lebensanzeigen über Monstern

Minenmonster, Dungeon-Gegner, Elitegegner und Bosse besitzen eine Anzeige direkt über ihrem Körper: Name, zwölfteiliger Lebensbalken und aktuelle/maximale Lebenspunkte. Dungeon-Gegner zeigen zusätzlich ihr Dungeon-Level.

Der Balken ist oberhalb von 50 % grün, bis 25 % gelb und darunter rot. Er verwendet die tatsächlichen Kampfwerte des Plugins, einschließlich der höheren Boss-, Dungeon- und Gruppenwerte. Verbleibende Bruchteile eines Lebenspunkts werden aufgerundet.

Treffer und Heilung aktualisieren die Anzeige sofort. Sie folgt dem Monster und wird bei Tod, Abbruch und Bereinigung mit entfernt. Persönliche Minengegner zeigen ihre Anzeige nur ihrem Besitzer; im Dungeon sieht die aktuelle Gruppe sie. Wände verdecken die Anzeige. Die vorhandene Bossleiste bleibt zusätzlich bestehen.

Kein neues Ressourcenpaket erforderlich. Automatisierte Formatierungsprüfungen und native Paper-Diagnosen prüfen Lebensänderungen, Bewegung und Entfernung. Eine visuelle Abnahme im Minecraft-Client steht noch aus.
