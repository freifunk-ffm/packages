#### Hintergrund
Durch dieses Gluon-Package wird sichergestellt, dass evtl. veränderte Wifi-Kanal-Einstellungen nach einem Sysupgrade automatisch wieder hergestellt werden. 
Unabhängig, vom Inhalt der Datei ‚site.conf‘.
  
  
#### Vorgehensweise
Das Skript **110-preserve-wireless-channels** stellt sicher, dass ggf. manuel duchgeführte Wifi-Kanal-Einstellungen erhalten bleiben (siehe https://gluon.readthedocs.io/en/v2018.2/features/wlan-configuration.html).

Nach einem Sysupgrade, jedoch vor dem ersten Reboot, werden Upgrade-Skripte automatisch abgearbeitet.  
Das Skript dieses Packages hängt sich in diese Skript-Abarbeitung ein (siehe https://gluon.readthedocs.io/en/v2018.2/dev/upgrade.html).
  

