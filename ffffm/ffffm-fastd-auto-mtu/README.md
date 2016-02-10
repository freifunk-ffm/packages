## ffffm-fastd-auto-mtu

Durch dieses Gluon-Package wird automatisch, in Abhängigkeit der Up-Link-Eigenschaften, die max. Fastd-MTU-Größe eingestellt.<br>

Bei jedem Boot-Prozess und bei aktiviertem 'mesh_vpn' wird untersucht, ob der Up-Link eine MTU von 1492 Byte unterstützt.<br>
Ist dieses der Fall, so wird die fastd-MTU auf 1426 Byte eingestellt.<br>
Andernfalls wird die fastd-MTU auf 1280 Byte zurückgesetzt.<br>
<br>
Hat sich die detektierte MTU-Größe verändert, so wird die neue MTU-Größe in 'fastd.fastd_mesh_vpn.mtu' gespeichert und fastd wird neu gestartet.<br>
<br>

**Einschalten** (default)
```
fastd.mesh_vpn.auto_mtu_enabled='1'
```
<br>
**Ausschalten**
```
fastd.mesh_vpn.auto_mtu_enabled='0'
```
<br>
Die fastd-MTU-Größen (1280 und 1426) sind hart in der Datei /lib/gluon/fastd-auto-mtu/automtu.lua hinterlegt.<br>
<br>
##### Abhängigkeiten
Dieses Package ist abhängig von folgenden Packages:<br>
 - iputils-ping
