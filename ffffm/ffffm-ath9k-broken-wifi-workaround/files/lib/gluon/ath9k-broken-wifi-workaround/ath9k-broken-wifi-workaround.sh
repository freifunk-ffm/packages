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
# 2) Sammeln aller Indikatoren für eine Client Lost Detektierung.
# 3) Ueberpruefen, ob Clients verbunden sind und dieses merken.
# 4) Ueberpruefen, ob mit einem Mesh verbunden und dieses merken.
# 5) Ueberpruefen ob eine Gateway/UpLink Verbindung vorhanden ist und dieses merken.
# 6) Auswerten von Client-Lost, Mesh-Lost, Gateway/UpLink-Lost.
# 7) Tratten innerhalb von zwei Skript-Aufrufzyklen Probleme auf, dann -> Wifi-Restart.
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

# Writes to an own log file in /tmp/log and to the systemlog
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
# 	systemlog "Autoupdater is running, aborting."
	exit
fi

# Check if node has wifi
if [ ! -L /sys/class/ieee80211/phy0/device/driver ] && [ ! -L /sys/class/ieee80211/phy1/device/driver ]; then
# 	systemlog "Node has no wifi, aborting."
	exit
fi

# Check if node uses ath9k wifi driver
if ! expr "$(readlink /sys/class/ieee80211/phy0/device/driver)" : ".*/ath9k" >/dev/null; then
	if ! expr "$(readlink /sys/class/ieee80211/phy1/device/driver)" : ".*/ath9k" >/dev/null; then
# 		systemlog "Node doesn't use the ath9k wifi driver, aborting."
		exit
	fi
fi


######################################################################################
# Observe ath9k driver problem indicators. Needed for the client lost check.
######################################################################################

# Check if the TX queue is stopped
STOPPEDQUEUE=0
if [ "$(grep BE /sys/kernel/debug/ieee80211/phy0/ath9k/queues | cut -d":" -f7 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	STOPPEDQUEUE=1
# 	systemlog "Observed a stopped queue, continuing."
fi

# Check TX Path Hangs
TXPATHHANG=0
if [ "$(grep "TX Path Hang" /sys/kernel/debug/ieee80211/phy0/ath9k/reset | cut -d":" -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	TXPATHHANG=1
#	systemlog "Observed a TX Path Hang, continuing."
fi

# Combine 
PROBLEMS=1
if [ "$STOPPEDQUEUE" -eq 0 ] && [ "$TXPATHHANG" -eq 0 ]; then
	PROBLEMS=0
# 	systemlog "No problem indicators observed."
fi


######################################################################################
# Check client connections (client lost)
######################################################################################

# Check if there are connected clients to this node
CLIENTCONNECTIONS=0
PIPE=$(mktemp -u -t workaround-pipe-XXXXXX)
# check for clients on each wifi device
mkfifo $PIPE
iw dev | grep Interface | cut -d" " -f2 | grep client > $PIPE &
while read wifidev; do
	iw dev $wifidev station dump 2>/dev/null | grep -q Station
	if [ $? -eq 0 ]; then
		CLIENTCONNECTIONS=1
# 		systemlog "Found wifi clients."
		break
	fi
done < $PIPE
rm $PIPE


# Remember if there were client connections after the last wifi restart or reboot
CLIENTFILE="/tmp/wifi-connection-active"
if [ ! -f "$CLIENTFILE" ] && [ "$CLIENTCONNECTIONS" -eq 1 ]; then
# 	systemlog "There are wifi connections after a previous boot or wifi restart."
	touch $CLIENTFILE
fi

######################################################################################
# Check mesh connection (mesh lost)
######################################################################################

# Check for an active ibss0 mesh
MESHCONNECTIONS=0
if iw dev ibss0 station dump | grep Station 2>&1
then
	MESHCONNECTIONS=1
# 	systemlog "Found a wifi mesh."
fi

# Remember if there were mesh connections after the last wifi restart or reboot
MESHFILE="/tmp/wifi-mesh-connection-active"
if [ ! -f "$MESHFILE" ] && [ "$MESHCONNECTIONS" -eq 1 ]; then
# 	systemlog "There are mesh connections after a previous boot or wifi restart."
	touch $MESHFILE
fi

######################################################################################
# Check gateway connection (uplink lost)
######################################################################################

# Try to ping the default gateway (mainly for wifi mesh only nodes needed)
GWCONNECTION=0
GATEWAY=$(batctl gwl | grep "^=>" | awk -F'[ ]' '{print $2}')
if [ $GATEWAY ]; then
	batctl ping -c 5 $GATEWAY > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		GWCONNECTION=1
# 		systemlog "Ping default gateway $GATEWAY ... Okay!"
	else
		systemlog "Can't ping default gateway $GATEWAY"
	fi
else
	systemlog "No default gateway defined"
fi

# Remember if the defaultgatewy was pingable after the last wifi restart or reboot
# Important for mesh clowd networking only 
GWFILE="/tmp/gateway-connection-active"
if [ ! -f "$GWFILE" ] && [ "$GWCONNECTION" -eq 1 ]; then
# 	systemlog "There are default gateway connections after a previous boot or wifi restart."
	touch $GWFILE
fi

######################################################################################
# Main wifi restart logik
######################################################################################

WIFIRESTART=0

# Client & Errors (hier ist die Logik noch irgendwie unstimmig)
if [ -f "$CLIENTFILE" ] && [ "$CLIENTCONNECTIONS" -eq 0 ] && [ "$PROBLEMS" -eq 1 ]; then
# There were lient connections before, but there are none at the moment and there are problem indicators.
	WIFIRESTART=1
	multilog "Client lost"
fi

# Mesh 
if [ -f "$MESHFILE" ] && [ "$MESHCONNECTIONS" -eq 0 ]; then
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

RESTARTFILE="/tmp/wifi-restart-pending"
if [ ! -f "$RESTARTFILE" ] && [ "$WIFIRESTART" -eq 1 ]; then
	touch $RESTARTFILE
	multilog "Wifi restart is pending"
elif [ $WIFIRESTART -eq 1 ]; then
	multilog "*** Wifi restarted ***"
	rm -rf $MESHFILE
	rm -rf $CLIENTFILE
	rm -rf $GWFILE
	rm -rf $RESTARTFILE
	/sbin/wifi
else
# 	systemlog "Everything seems to be ok"
	rm -rf $RESTARTFILE
fi
