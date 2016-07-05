##### Hintergrund
Es wird versucht, die Anzahl der kleinen Datenpakete vom Router zum Supernode zu minimieren.  
Hierfür ist u.a. geplant die DNS-Anfragen der Clients zu den Supernodes zu reduzieren.

<br>

##### Das Packages
Durch dieses Package wird der Cache der Router-dnsmasq-Instanz, welche auf Port 53 horcht, vergrößert.  
Nach einer Supernode-DHCP-Anpassung fungieren die FF-Router dann als DNS-Proxy.


Siehe auch:
https://wiki.openwrt.org/doc/uci/dhcp  
http://flux242.blogspot.de/2012/06/dnsmasq-cache-size-tuning.html



