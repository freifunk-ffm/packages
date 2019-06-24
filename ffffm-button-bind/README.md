## ffffm-button-bind

Mit diesem Package können im Router-Konfigurationsmodus dem Router-Wifi-Taster eigene Funktionalitäten zugeordnet werden.  

![](https://github.com/oszilloskop/DiesUndDas/raw/master/images/Button-Bind%232.png)

Das Package passt die Funktionalität des Wifi-Taster über das Skript `/etc/rc.button/rfkill` an.

Es stehen folgende Tasterfunktionalitäten zur Verfügung:

**Wifi ON/OFF Taster:**

0. Wifi an/aus (`uci set button-bind.wifi.function=0; uci commit`) 
1. Keine Funktion (default) (`uci set button-bind.wifi.function=1; uci commit`)
2. Wifi-Reset (`uci set button-bind.wifi.function=2; uci commit`) 
3. Nachtmodus - LEDs generell aus, aber während Taster-Betätigung LEDs an (`uci set button-bind.wifi.function=3; uci commit; reboot`)


---
## Forks
Dieses Package wurd von rubo77 (Freifunk Nord) stark weiterentwicklet. Sein Repo ist hier zu finden: https://github.com/rubo77/ffm-packages
