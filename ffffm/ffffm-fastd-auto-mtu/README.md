## ffffm-fastd-auto-mtu

In Abhängigkeit der Up-Link-Eigenschaften wird durch dieses Gluon-Package automatisch eine kleine oder eine große fastd-MTU-Größe eingestellt.<br>

Bei jedem Boot-Prozess und bei aktiviertem 'mesh_vpn' wird untersucht, ob der Up-Link eine MTU-Größe von z.B. 1492 Byte (Telekom-DSL) unterstützt.<br>
Ist dieses der Fall, so wird die fastd-MTU-Größe auf z.B. auf 1426 Byte eingestellt.<br>
Andernfalls wird die fastd-MTU-Größe auf z.B. 1280 Byte zurückgesetzt.<br>
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

In der **site.conf** muss eine Sektion **fastd_auto_mtu** mit folgenden Paramtern angelegt werden:<br>

```
...
  fastd_auto_mtu = {
    mtu_fastd_low = 1280,       -- kleine fastd MTU-Size
    mtu_fastd_high = 1426,      -- große fastd MTU-Size
    mtu_uplink_max = 1492,      -- max. Uplink-MTU-Size
    ping_target = '8.8.8.8',    -- IP oder Hostname des Ping-Zieles
    delay_time = 10,            -- Wartezeit wegen/für x86-Targets
    wan_if = 'br-wan',          -- Name Up-Link Interface
  },
...
```

<br>

##### Abhängigkeiten
Dieses Package ist abhängig von folgenden Packages:<br>
 - iputils-ping
