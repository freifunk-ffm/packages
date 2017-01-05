##ffffm-disable-wifi-button

Mit diesem Package wird der WDS/WiFi-Taster eines Routers deaktiviert.  

Es werden einmalig 'wlan0' und 'wlan1' aktiviert und dann wird das WDS/WiFi-Taster-Auswertskript `/etc/rc.button/rfkill` so verändert, dass es keine Reaktion bei einer Betätigung ausgeführt wird.  

Das angepasste Skript `/etc/rc.button/rfkill` trägt einen Betätigungseintrag in die Log-Datei ein. 

####Ergänzung:  
Als klitze kleine Funktionserweiterung wird jetzt bei der Betätigung des Wifi/WDS-Tasters der Wifi-Treiber neu durchgestartet.  
Falls also doch nochmal ein Router wegen des ath9k-Problems Wifi-technisch auffällig wird, so kann einfach getestet werden, ob es am ath9k-Treiber lag (ohne dass der Router hart aus und wieder eingeschaltet werden muss).
