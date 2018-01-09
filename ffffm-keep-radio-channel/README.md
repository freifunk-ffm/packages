#### Hintergrund
Durch dieses Gluon-Package wird sichergestellt, dass evtl. veränderte Wifi-Kanal-Einstellungen nach einem Sysupgrade automatisch wieder hergestellt werden. 
Unabhängig, vom Inhalt der Datei ‚site.conf‘.
  
  
#### Vorgehensweise
Das Skript **110-preserve-wireless-channels** stellt sicher, dass ggf. manuel duchgeführte Wifi-Kanal-Einstellungen erhalten bleiben (siehe http://gluon.readthedocs.io/en/v2017.1.4/features/wlan-configuration.html#upgrade-behaviour).

Nach einem Sysupgrade, jedoch vor dem ersten Reboot, werden Upgrade-Skripte automatisch abgearbeitet.  
Die Skripte dieses Packages hängen sich in die Skript-Abarbeitung diese ein (siehe http://gluon.readthedocs.org/en/latest/dev/upgrade.html).
  

