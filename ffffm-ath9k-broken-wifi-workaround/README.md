### ath9k-broken-wifi-workaround
Der ath9k WLAN-Treiber macht Probleme (Stand 06/2016).<br>
Siehe:

* https://github.com/freifunk-gluon/gluon/issues/130
* https://github.com/freifunk-gluon/gluon/issues/605
* https://github.com/freifunk-gluon/gluon/pull/2114

Dieses Package identifiziert einen hängenden ath9k WLAN-Treiber und startet ihn ggf. neu durch.

Durch dieses Package wird zyklisch, alle 2 Minuten, das Skript [`/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh`](https://github.com/freifunk-ffm/packages/blob/master/ffffm/ffffm-ath9k-broken-wifi-workaround/files/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh) aufgerufen. Der micronjob ist unter `/usr/lib/micron.d/ath9k-broken-wifi-workaround` zu finden.  

* Tritt ein Probleme erstmalig auf, dann ist der erste Lösungsversuch ein `'iw device scan'`. Dieser Scan behebt im ersten Schritt einfachere Treiber-Probleme.  
* Detektiert das Skript in zwei aufeinanderfolgenden Aufrufen ein Problem, so wird der Wifi-Treiber mit dem Befehl `'wifi'` resetet.  


Anmerkung:  
Bei hohem Durchsatz hat der ath9k-Treiber auch einen Einfluß auf einen ggf. vorhandenen ath10k-Treiber. Beim ath10k-Treiber kann es dann in Folge manchmal zu Fehlfunktionen kommen.<br>
Siehe:

* https://forum.openwrt.org/t/ath10k-pci-0000-01-00-0-swba-overrun-on-vdev-0-skipped-old-beacon/5002

<br>
### Kleine Funktionsbeschreibung:

1) Überprüfen, ob überhaupt ein Problemtest durchgeführt werden kann/soll.  
2) Überpruefen ob eine Gateway/UpLink Verbindung besteht und dieses merken.
3) Auswertung über die Zeit von Gateway/UpLink. 
4) Überprüfung von auffälligen in dmesg-Logeinträgen  
5) Tritt ein Probleme erstmalig auf, dann ist der erste Lösungsversuch ein iw-Scan. Dieser Scan behebt im ersten Schritt einfachere Treiber-Probleme.  
6) Traten innerhalb von zwei Skript-Aufrufzyklen Probleme auf, dann -> Wifi-Restart.    
<br>

### Logging
Aktivitäten des Workarounds werden in der Datei `/tmp/log/ath9k-wifi-problem-timestamps` aufgezeichnet. 
<br>
**Es werden nur die letzten 22 Einträge in der Logdatei vorgehalten!**

Folgende Probleme werden detektiert und mit Zeitstempel aufgezeichnet:

* All wifi connectivity (client/mesh/private) lost
* Mesh lost
* No path to the default gateway xx:yy::zz
* Just an info: TX queue is stopped and TX path hangs   (-> Schlangenöl, daher wird es vom Workaround ignoriert!)  

Einer Problembeschreibung schliesst sich immer eine der folgenden Meldungen an:
 
* Wifi restart is pending
* \*\*\* Wifi restarted \*\*\*

An der/den Meldungen ist zu sehen, ob gerade mittles 'wifi' der Ath9k-Treiber neu gestrartet wurde oder werden soll.

<br>
## Achtung:

#### Dieses Package entfernt nicht die Ursached des Problems. 

#### Es verhindert lediglich, dass sich WLAN-meshende Router nicht dauerhaft vom Netz trennen. 
<br>
<br>

### Quelle
Basis ist eine Version des Packages von Freifunk Altdorf.<br>
Siehe https://github.com/tecff/gluon-packages/tree/master/tecff-ath9k-broken-wifi-workaround

