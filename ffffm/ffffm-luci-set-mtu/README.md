## ffffm-luci-set-mtu

Durch dieses Gluon-Package kann per GUI im Konfig-Modus die fastd-MTU-Blockgröße eingestellt werden.<br>
<br>
In der **site.conf** muss die Sektion **mtu_posible_size** angelegt werden.<br>
In dieser Liste werden alle möglichen MTU-Grössen eingetragen.<br>

Beispiel:
```
...
fastd_mesh_vpn = {
   mtu_posible_size = {
      list = {
         '1280',
         '1426',
      },
    },
...
```

<br>

##### Abhängigkeiten

Dieses Package ist abhängig von folgenden Packages:<br>
 - ffffm-fastd-auto-mtu
