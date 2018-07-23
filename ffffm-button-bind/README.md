## ffffm-button-bind

Mit diesem Package können im Router-Konfigurationsmodus dem Router-Wifi-Taster eigene Funktionalitäten zugeordnet werden. (Alternativ kann dieses auch per `uci` durchgeführt werden.)

![](https://user-images.githubusercontent.com/1591563/29782999-057eb41a-8c1f-11e7-969f-31ce6af40911.png)

Das Paket passt den Wifi-Taster über das Skript `/etc/rc.button/rfkill` an.

Es stehen folgende Tasterfunktionalitäten zur Verfügung:

**Wifi ON/OFF Taster:**

0. Wifi an/aus (`uci set button-bind.wifi.function=0; uci commit`) 
1. Keine Funktion **(default)** (`uci set button-bind.wifi.function=1; uci commit`)
2. Wifi-Reset (`uci set button-bind.wifi.function=2; uci commit`) 
3. Nachtmodus 1, alle Status-LEDs an/aus (`uci set button-bind.wifi.function=3; uci commit; reboot`)
4. Nachtmodus 2, alle Status-LEDs aus, an solange man den Taster gedrückt hält (`uci set button-bind.wifi.function=4; uci commit; reboot`)
5. Client-Netz an/aus (`uci set button-bind.wifi.function=5; uci commit`)
6. Mesh-VPN aus für 5 Stunden (`uci set button-bind.wifi.function=6; uci commit`)

Bei der Option 5. bleibt das Mesh-Netz aktiv, so dass der Router weiter mit der
lokalen Wolke und eventuellen Gateways über das Mesh-VPN mascht.

Bei Option 6. schaltet sich das Mesh-VPN nach 5 Stunden automatisch wieder ein.
Man kann durch nochmaliges Drücken diesen Timer abbrechen und das das Mesh-VPN
sofort wieder einschalten.

**Hinweis zur uci-Nutzung**

Bei älteren Versionen dieses Pakets wurde nicht immer die Datei `/etc/config/button-bind` angelegt.

Wenn dieses der Fall sein sollte, dann einfach folgenden Inhalt auf dem Router in die leere Datei `/etc/config/button-bind` einfügen: 
```
config button 'wifi'  
	option function '1'
```
