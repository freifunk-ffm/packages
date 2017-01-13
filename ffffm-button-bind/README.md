##ffffm-button-bind

Mit diesem Package können im Konfigurationsmodus den Router-Tastern eigene Funktionalitäten zugeordnet werden.  

Alternativ kann dieses auch per 'uci' durchgeführt werden.

Das Package passt z.Z. nur den Wifi-Taster über das Skript `/etc/rc.button/rfkill` an.

Zur Zeit stehen folgende Tasterfunktionalitäten zur Verfügung:

**Wifi ON/OFF Taster:**

- Wifi an/aus (default) (`uci set button-bind.wifi.function=0`) 
- Keine Funktion (`uci set button-bind.wifi.function=1`)
- Wifi-Reset (`uci set button-bind.wifi.function=2`) 
- Temporäres Aktivieren der Status-LEDs (`uci set button-bind.wifi.function=3`, Reboot notwendig)
