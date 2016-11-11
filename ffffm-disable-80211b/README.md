# Dieses Package ist seit Gluon 2016.2.x Obsolet!
### Hintergrund

Bei **2,4GHz** Geräten kann einiges an Airtime gespart werden, wenn 802.11b deaktiviert wird.
  
> In addition to the overhead created by the SSID’s you also have 
> 802.11g protection mechanism that requires sending of an 802.11b packet 
> reserving the airtime to then send the 802.11g or 802.11n packet – 
> that’s two packets for every single user data packet – and this 
> translates to as much as a 50% reduction of available bandwidth.
>    
> See – a very high tax indeed. Stop the madness – turn it off.
> Disabling 1,2,5.5, and 11 Mbps data rates will dramatically improve 2.4 
> GHz availability availability for usable traffic and throughput, which 
> can translate to a savings of 30-50%.    
   
Siehe auch:   
[https://forum.ortenau.freifunk.net/t/wlan-802-11b-abschalten-fuer-mehr-performance](https://forum.ortenau.freifunk.net/t/wlan-802-11b-abschalten-fuer-mehr-performance)

<br>
### Vorgehensweise
In die Datei `/etc/config/wireless` wird nach dem Flashen bzw. nach einem Sysupgrade folgendes eingetragen:

```
config wifi-device 'radio0'
		option type 'mac80211'
		...
		list basic_rate '6000 9000 12000 24000 54000'
		list supported_rates '6000 9000 12000 18000 24000 36000 48000 54000'

		config wifi-iface 'client_radio0'
		...        
```
