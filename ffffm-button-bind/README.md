## ffffm-button-bind

Mit diesem Package können im Router-Konfigurationsmodus dem Router-Wifi-Taster
eigene Funktionalitäten zugeordnet werden. (Alternativ kann dieses auch per
`uci` durchgeführt werden.)

![](https://forum.freifunk.net/uploads/default/original/2X/e/e9944dcf6897939145e686bf56ec257106ac30b0.png)

Das Paket passt den Wifi-Taster über das Skript `/etc/rc.button/rfkill` an.

Es stehen folgende Tasterfunktionalitäten zur Verfügung:

**Wifi ON/OFF Taster:**

0. Wifi an/aus (`uci set button-bind.wifi.function=0; uci commit`) 
1. Keine Funktion (default) (`uci set button-bind.wifi.function=1; uci commit`)
2. Wifi-Reset (`uci set button-bind.wifi.function=2; uci commit`) 
3. Nachtmodus - LEDs aus, aber während Taster-Betätigung an (`uci set button-bind.wifi.function=3; uci commit; reboot`)

Bei 3. startet der Knoten immer im Nachtmodus, dies funktioniert auch bei
Garäten, die keinen Taster haben. Ohne Taster bekommt man die LESs allerdings
dann auch nur hier im Config Mode wieder an.


**Hinweis zur uci-Nutzung**

Bei älteren Versionen dieses Pakets wurde nicht immer die Datei `/etc/config/button-bind` angelegt.

Wenn dieses der Fall sein sollte, dann einfach folgenden Inhalt auf dem Router
in die leere Datei `/etc/config/button-bind` einfügen: 
```
config button 'wifi'  
	option function '1'
```
