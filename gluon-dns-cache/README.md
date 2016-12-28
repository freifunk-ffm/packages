##### Hintergrund
Es wird versucht, die Anzahl der kleinen Datenpakete vom Router zum Supernode zu minimieren.  
Hierfür ist u.a. geplant die DNS-Anfragen der Clients zu den Supernodes zu reduzieren.

<br>

##### Das Packages
Durch dieses Package wird der Cache der Router-dnsmasq-Instanz, welche auf Port 53 horcht, vergrößert.  
Nach einer Supernode-DHCP-Anpassung fungieren die FF-Router dann als DNS-Proxy.

#### Konfiguration
Die Konfiguration erfolgt per site.conf mit folgenden Parametern:
  dns = {
    cacheentries = 5000,
    servers = { '2a06:8187:fb00:53::53' , } ,
    internaldomain = 'ffffm',
  }

cacheentries ist die Anzahl der Einträge, die der Cache haben soll. Je Eintrag
werden ca 90 Byte Ram benötigt. Der Ram für alle Einträge wird als Block beim
Systemstart reserviert.

servers ist der vom cache genutzte Upstream DNS-Server

internaldomain ist der Domainname, der intern im Freifunknetz genutzt wird.



Siehe auch:
https://wiki.openwrt.org/doc/uci/dhcp  
http://flux242.blogspot.de/2012/06/dnsmasq-cache-size-tuning.html



