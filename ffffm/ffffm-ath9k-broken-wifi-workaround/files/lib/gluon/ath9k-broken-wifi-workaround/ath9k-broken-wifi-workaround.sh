#!/bin/sh

######################################################################################
# 
# Dateiname:
# ath9k-broken-wifi-workaround.sh
# 
# Aufruf:
# /lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh
# (keine Uebergabeparameter)
# 
# Cronjob:
# Dieses Skript muss zyklisch aufgerufen werden. 
# Z.z. ueber /usr/lib/micron.d/ath9k-broken-wifi-workaround alle 2 Minuten.
# 
# Funktion:
# 1) Ueberpruefen, ob ueberhaupt ein Problemtest durchgefuehrt werden kann/soll.
# 2) Ueberpruefen, welche WLAN-Konnektivitaet vorhanden ist und dieses merken.
# 4) Ueberpruefen ob eine Gateway/UpLink Verbindung besteht und dieses merken.
# 5) Auswerten ueber die Zeit von WLAN Konnektivitaet, aktivem Mesh, Gateway/UpLink.
# 6) Tratten innerhalb von zwei Skript-Aufrufzyklen Probleme auf, dann -> Wifi-Restart.
# 
# Ausgabe:
# Es werden Ereignisse in die eigens definierte Logdatei /tmp/log/wifi-problem-timestamps
# und in den Systemlog eingetragen.
# 
###################################################################################### 


######################################################################################
# 
# Zum Debuggen und selber Rumbasteln einfach die "#" vor allen "systemlog XYZ" entfernen
# 
######################################################################################


###################################################################################### 
# Alle Kommentarzeilen werden durch das Makefile des Packages entfernt
# sed -i '/^# /d' ath9k-broken-wifi-workaround.sh
# sed -i '/^##/d' ath9k-broken-wifi-workaround.sh
# 
######################################################################################


######################################################################################
# 
# Devise: 
# Lieber einmal mehr als einmal weniger :o)
# 
######################################################################################


CLIENTFILE="/tmp/wifi-ath9k-client-connect"
PRIVATEFILE="/tmp/wifi-ath9k-private-connect"
MESHFILE="/tmp/wifi-ath9k-mesh-connect"
GWFILE="/tmp/gateway-ath9k-connect"

RESTARTFILE="/tmp/wifi-restart-pending"


######################################################################################
# Locale functions
######################################################################################

LOGFILE="/tmp/log/wifi-problem-timestamps"
LPREFIX="ath9k-broken-wifi-workaround"

# Writes to the system log file
systemlog() {
echo "$LPREFIX: $1"
logger "$LPREFIX: $1"
}

# Writes to an own log file in /tmp/log and to the systemlog as well
# Ringbuffer, limit own log file to MAX_LINES
multilog() {
MAX_LINES=25
RINGFILE=$(mktemp -t wifi-tmp-XXXXXX)
echo "$(date) - $1" >> $LOGFILE
tail -n $MAX_LINES $LOGFILE > $RINGFILE
cp $RINGFILE $LOGFILE
rm -rf $RINGFILE
systemlog "$1"
}


######################################################################################
# Check test start conditions
######################################################################################

# Check autoupdater 
pgrep autoupdater >/dev/null
if [ "$?" == "0" ]; then
# 	systemlog "Autoupdater is running, aborting"
	exit
fi

# Check if node has wifi
if [ ! -L /sys/class/ieee80211/phy0/device/driver ] && [ ! -L /sys/class/ieee80211/phy1/device/driver ]; then
# 	systemlog "Node has no wifi, aborting"
	exit
fi

# Check if node uses ath9k wifi driver
if ! expr "$(readlink /sys/class/ieee80211/phy0/device/driver)" : ".*/ath9k" >/dev/null; then
	if ! expr "$(readlink /sys/class/ieee80211/phy1/device/driver)" : ".*/ath9k" >/dev/null; then
# 		systemlog "Node doesn't use the ath9k wifi driver, aborting"
		exit
	fi
fi

######################################################################################
# Check client wifi connectivity (client lost)
######################################################################################

# Check if there are client connectivity to this node
CLIENTCONNECTION=0

if iw dev client0 station dump | grep Station 2>&1
then
	CLIENTCONNECTION=1
	touch $CLIENTFILE
# 	systemlog "Found client connectivity"
fi

######################################################################################
# Check private wifi connectivity (private wifi lost)
######################################################################################

# Check if there are privat wifi connectivity to this node
PRIVATECONNECTION=0

if iw dev wlan0-1 station dump | grep Station 2>&1
then
	PRIVATECONNECTION=1
	touch $PRIVATEFILE
# 	systemlog "Found private device connectivity"
fi

######################################################################################
# Check ibss0 mesh connection (mesh lost)
######################################################################################

# Check for an active ibss0 mesh
MESHCONNECTION=0
if iw dev ibss0 station dump | grep Station 2>&1
then
	MESHCONNECTION=1
	touch $MESHFILE
# 	systemlog "Found a mesh"
fi

######################################################################################
# Check gateway connection (uplink lost)
######################################################################################

# Try to ping the default gateway (needed mainly for wifi mesh only nodes)
GWCONNECTION=0
GATEWAY=$(batctl gwl | grep "^=>" | awk -F'[ ]' '{print $2}')
if [ $GATEWAY ]; then
	RANDOM=$(awk 'BEGIN { srand(); printf("%d\n",rand()*25) }')
	sleep $RANDOM
	batctl ping -c 5 $GATEWAY > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		GWCONNECTION=1
		touch $GWFILE
# 		systemlog "Ping default gateway $GATEWAY ... Okay!"
	else
		systemlog "Can't ping default gateway $GATEWAY"
	fi
else
	systemlog "No default gateway defined"
fi

######################################################################################
# Main wifi restart logik
######################################################################################

WIFIRESTART=0

# All wifi connectivity lost
if [ "$CLIENTCONNECTION" -eq 0 ] && [ "$MESHCONNECTION" -eq 0 ] && [ "$PRIVATECONNECTION" -eq 0 ]; then
	# There were wifi connectivity before, but there are none at the moment.
	if [ -f "$CLIENTFILE" ] || [ -f "$MESHFILE" ] || [ -f "$PRIVATEFILE" ]; then
		# There were client or mesh connectivity before, but there are none at the moment.
		WIFIRESTART=1
		multilog "All wifi connectivity (client/mesh/private) lost"
	fi
fi

# Mesh lost. This double check is just for safety reasons.		
if [ -f "$MESHFILE" ] && [ "$MESHCONNECTION" -eq 0 ]; then		
	# There were mesh connections before, but there are none at the moment.		
	WIFIRESTART=1
	multilog "Mesh lost"
fi

# No pingable default gateway.
if [ -f "$GWFILE" ] && [ $GWCONNECTION -eq 0 ]; then
	WIFIRESTART=1
	multilog "No path to the default gateway $GATEWAY"
fi 


######################################################################################
# Should I really do it?
######################################################################################

if [ ! -f "$RESTARTFILE" ] && [ "$WIFIRESTART" -eq 1 ]; then
	touch $RESTARTFILE
	multilog "Wifi restart is pending"
elif [ $WIFIRESTART -eq 1 ]; then
	multilog "*** Wifi restarted ***"
	rm -rf $CLIENTFILE
	rm -rf $MESHFILE
	rm -rf $PRIVATEFILE
	rm -rf $GWFILE
	rm -rf $RESTARTFILE
	/sbin/wifi
else
# 	systemlog "Everything seems to be ok"
	rm -rf $RESTARTFILE
fi
