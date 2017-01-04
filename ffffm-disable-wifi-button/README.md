##ffffm-disable-wifi-button

Mit diesem Package wird der WiFi-Taster bzw. -Schalter eines Routers deaktiviert.  

Es werden einmalig 'wlan0' und 'wlan1' aktiviert und dann wird das WiFi-Taster-Auswertskript `/etc/rc.button/rfkill` so verändert, dass es keine Reaktion bei einer Betätigung durchgeführt wird.  

Das angepasste Skript `/etc/rc.button/rfkill` trägt einen Betätigungseintrag in die Log-Datei ein. 

