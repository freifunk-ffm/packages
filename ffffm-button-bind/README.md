##ffffm-button-bind

Mit diesem Package können im Router-Konfigurationsmodus den Router-Tastern eigene Funktionalitäten zugeordnet werden. (Alternativ kann dieses auch per 'uci' durchgeführt werden.)

![](https://forum.freifunk.net/uploads/default/original/2X/e/e9944dcf6897939145e686bf56ec257106ac30b0.png)

Das Package passt z.Z. nur den Wifi-Taster über das Skript `/etc/rc.button/rfkill` an.

Zur Zeit stehen folgende Tasterfunktionalitäten zur Verfügung:

**Wifi ON/OFF Taster:**

- Wifi an/aus (default) (`uci set button-bind.wifi.function=0; uci commit`) 
- Keine Funktion (`uci set button-bind.wifi.function=1; uci commit`)
- Wifi-Reset (`uci set button-bind.wifi.function=2; uci commit`) 
- Temporäres Aktivieren der Status-LEDs (`uci set button-bind.wifi.function=3; uci commit; reboot`)


**Hinweis:**

Falls diese Funktion noch nie auf dem Router im Router-Konfigurationsmodus konfiguriert wurde, so muss noch händisch eine Datei auf dem Router angepasst werden.

Einfach folgenden Inhalt auf dem Router in die leere Datei `/etc/config/button-bind` einfügen: 
```
config button 'wifi'  
	option function '0'
```
