##### Hintergrund
<br>
Durch dieses Gluon-Package wird sichergestellt, dass evtl. veränderte Wifi-Kanal-Einstellungen nach einem Sysupgrade automatisch wieder hergestellt werden. 
Unabhängig, vom Inhalt der Datei ‚site.conf‘.<br>
<br>
##### Vorgehensweise
Nach einem Sysupgrade, jedoch vor dem ersten Reboot, werden Upgrade-Skripte automatisch abgearbeitet.<br>
Die Skripte dieses Packages hängen sich in die Skript-Abarbeitung ein<br>
(siehe http://gluon.readthedocs.org/en/latest/dev/upgrade.html).<br>
<br>
Das Skript **110-preserve-wireless-channels** stellt sicher, dass ggf. manuel duchgeführte Wifi-Kanal-Einstellungen erhalten bleiben (siehe http://gluon.readthedocs.io/en/v2017.1.4/features/wlan-configuration.html#upgrade-behaviour).<br>
<br>
<br>
