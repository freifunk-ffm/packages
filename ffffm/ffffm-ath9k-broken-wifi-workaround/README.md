### ath9k-broken-wifi-workaround
Der ath9k WLAN-Treiber macht Probleme (Stand 06/2016).<br>
Siehe:

* https://github.com/freifunk-gluon/gluon/issues/130
* https://github.com/freifunk-gluon/gluon/issues/605

Dieses Package identifiziert einen hängenden ath9k WLAN-Treiber und startet ihn ggf. neu durch.

Durch dieses Package wird zyklisch, alle 2 Minuten, [das Skript `/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh`](https://github.com/freifunk-ffm/packages/blob/master/ffffm/ffffm-ath9k-broken-wifi-workaround/files/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh) aufgerufen. Der micronjob ist unter `/usr/lib/micron.d/ath9k-broken-wifi-workaround` zu finden.  

Detektiert das Skript in zwei aufeinanderfolgenden Aufrufen ein Problem, so wird der Wifi-Treiber mit dem Befehl `'wifi'` resetet.  

Die Devise des Workaround lautet: **"Lieber einmal mehr als einmal weniger."**

<br>
### Kleine Funktionsbeschreibung:

1) Überprüfen, ob überhaupt ein Problemtest durchgeführt werden kann/soll.  
2) Auswertung von einigen ath9k Treiber-Flags. Ist wahrscheinlich Schlangenoil !?!  
3) Überprüfen, welche Art von WLAN-Konnektivitaet (Mesh/Client/privat) vorhanden ist und dieses merken.  
4) Überprüfen ob eine Gateway/UpLink Verbindung besteht und dieses merken.  
5) Auswerten über die Zeit von WLAN Konnektivität, aktivem Mesh, Gateway/UpLink.  
6) Tratten innerhalb von zwei Skript-Aufrufzyklen Probleme auf, dann -> Wifi-Restart.  

<br>

### Logging
Aktivitäten des Workarounds werden in der Datei `/tmp/log/ath9k-wifi-problem-timestamps` aufgezeichnet. 

Folgende Probleme werden detektiert und mit Zeitstempel aufgezeichnet:

* All wifi connectivity (client/mesh/private) lost
* Mesh lost
* No path to the default gateway xx:yy::zz
* TX queue is stopped and TX path hangs

Einer Problembeschreibung schliesst sich immer eine der folgenden Meldungen an:
 
* Wifi restart is pending
* \*\*\* Wifi restarted \*\*\*

<br>
## Achtung:
##### Dieses Package entfernt nicht die Ursached des Problems. 
##### Es verhindert lediglich, dass sich WLAN-meshende Router nicht dauerhaft vom Netz trennen. 
<br>
<br>
##### Quelle
Basis ist eine frühe Version des Packages von Freifunk Altdorf.<br>
Siehe https://github.com/tecff/gluon-packages/tree/master/tecff-ath9k-broken-wifi-workaround

