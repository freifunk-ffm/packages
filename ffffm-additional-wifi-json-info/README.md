 ## Dieses Package ist obsolet. 
 ## Es wird durch das Gluon-Modul '[respondd-module-airtime](https://github.com/freifunk-gluon/packages/tree/master/net/respondd-module-airtime)' ersetzt.
 Durch dieses Package werden zusätzliche Informationen durch respondd in die Info-JSON-Datei gepackt.
 Wie z.B.
 - Verwendeter Wifi-Kanal
 - Airtime
 - Nexthop
 

Hinweis:   
Map-JSON Informationen können auf einem Router mit folgenden Befehlen angezeigt werden:

```
gluon-neighbour-info -d ::1 -p 1001 -t 1 -r nodeinfo
gluon-neighbour-info -d ::1 -p 1001 -t 1 -r statistics
```

