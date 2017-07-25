##ffffm-button-bind

Mit diesem Package können im Router-Konfigurationsmodus dem Router-Wifi-Taster eigene Funktionalitäten zugeordnet werden. (Alternativ kann dieses auch per `uci` durchgeführt werden.)

![](https://forum.freifunk.net/uploads/default/original/2X/e/e9944dcf6897939145e686bf56ec257106ac30b0.png)

Das Package passt den Wifi-Taster über das Skript `/etc/rc.button/rfkill` an.

Es stehen folgende Tasterfunktionalitäten zur Verfügung:

**Wifi ON/OFF Taster:**

- Wifi an/aus (default) (`uci set button-bind.wifi.function=0; uci commit`) 
- Keine Funktion (`uci set button-bind.wifi.function=1; uci commit`)
- Wifi-Reset (`uci set button-bind.wifi.function=2; uci commit`) 
- alle Status-LEDs an/aus (`uci set button-bind.wifi.function=3; uci commit; reboot`)
- Client-Netz an/aus (`uci set button-bind.wifi.function=4; uci commit`)

**Hinweis für uci Nutzung**

Bei älteren Versionen dieses Package wurde nicht immer die Datei `/etc/config/button-bind` angelegt.

Wenn dieses der Fall sein sollte, dann einfach folgenden Inhalt auf dem Router in die leere Datei `/etc/config/button-bind` einfügen: 
```
config button 'wifi'  
	option function '0'
```
