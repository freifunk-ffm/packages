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

---

Folgende Grafik ist hilfreich zur Bestimmung einer optimalen fastd MTU Size.  
Die in der Grafik aufgezeigten Werte sind so kalkuliert, dass keine Fragmentierung innerhalb des Payloads stattfindet.
Wie mann feststellen kann, entsprechen diese Werte nicht den weit verbreiteten Werten innerhalb der Freifunkwelt. In Frankfurt testen wir gerade diese Werte (seit Ende 2016) .  

![image](https://camo.githubusercontent.com/101dc476455d2eae69f958544993670cfba65289/68747470733a2f2f66666d2e6672656966756e6b2e6e65742f77702d636f6e74656e742f75706c6f6164732f323031362f31312f422e412e542e4d2e412e4e2d4d54552d63616c63756c6174696f6e2d68656c7065722d73686565742e706e67)

---

##### Abhängigkeiten
Dieses Package ist abhängig von folgenden Packages:<br>
 - iputils-ping
