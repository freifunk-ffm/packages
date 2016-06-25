#!/bin/sh

################################################################################
# 
# Merke: Lieber ein "wifi" mehr als einmal weniger :o)
# 
################################################################################
# 
# Alle Kommentare und Leerzeilen werden durch das Makefile des Packages geloescht
# sed -i '/^# /d' ath9k-broken-wifi-workaround.sh
# sed -i '/^##/d' ath9k-broken-wifi-workaround.sh
# sed -i /^$/d ath9k-broken-wifi-workaround.sh
# 
################################################################################


LPREFIX="ath9k-broken-wifi-workaround"

################################################################################
# Locale functions
################################################################################

DEBBUG=1 

logg() {
if [ $DEBBUG -eq 1 ]; then
	echo "$LPREFIX: $1"
	logger "$LPREFIX: $1"
fi
}

# Ringbuffer, limit file to MAX_LINES lines
to_wifilog() {
MAX_LINES=20
RING=$(mktemp -t wifi-tmp-XXXXXX)
echo $(date) >> $1
tail -n $MAX_LINES $1 > $RING
cp $RING $1
rm -rf $RING
logger "$LPREFIX: Wifi will restart - Reasons see $1"
}


################################################################################
# Check test start conditions
################################################################################

# Wait a few minutes after boot
# UPTIME=$(cat /proc/uptime | awk -F'[.]' '{print $1}')
# SECWAIT="300"
# if [ $UPTIME -lt $SECWAIT ]; then
# 	logg "Device startup time not finished yet, exit."
# 	logg "Uptime: $UPTIME"
# 	exit
# fi

RUNFILE="/tmp/wifi-workaround-activ"
WAITFILE="/tmp/wifi-workaround-standby"

# After first script run or after a wifi restart wait a few minutes 
if [ ! -f "$RUNFILE" ]; then 
	touch $RUNFILE
	touch $WAITFILE
fi

if [ -f "$WAITFILE" ]; then 
	mv $WAITFILE $WAITFILE-1 
	exit
elif [ -f "$WAITFILE-1" ]; then 
	mv $WAITFILE-1 $WAITFILE-2
	exit
elif [ -f "$WAITFILE-2" ]; then 
	mv $WAITFILE-2 $WAITFILE-3
	exit
elif [ -f "$WAITFILE-3" ]; then 
	rm $WAITFILE-3
    exit
fi

# Check autoupdater 
pgrep autoupdater >/dev/null
if [ "$?" == "0" ]; then
	logg "Autoupdater is running, aborting."
	exit
fi

# Check if node has wifi
if [ ! -L /sys/class/ieee80211/phy0/device/driver ] && [ ! -L /sys/class/ieee80211/phy1/device/driver ]; then
	logg "Node has no wifi, aborting."
	exit
fi

# Check if node uses ath9k wifi driver
if ! expr "$(readlink /sys/class/ieee80211/phy0/device/driver)" : ".*/ath9k" >/dev/null; then
	if ! expr "$(readlink /sys/class/ieee80211/phy1/device/driver)" : ".*/ath9k" >/dev/null; then
		logg "Node doesn't use the ath9k wifi driver, aborting."
		exit
	fi
fi


################################################################################
# Observe ath9k driver problem indicators. Needed for the client lost check.
################################################################################

# Check if the TX queue is stopped
STOPPEDQUEUE=0
if [ "$(grep BE /sys/kernel/debug/ieee80211/phy0/ath9k/queues | cut -d":" -f7 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	STOPPEDQUEUE=1
	logg "Observed a stopped queue, continuing."
fi

# Check TX Path Hangs
TXPATHHANG=0
if [ "$(grep "TX Path Hang" /sys/kernel/debug/ieee80211/phy0/ath9k/reset | cut -d":" -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	TXPATHHANG=1
	logg "Observed a TX Path Hang, continuing."
fi

# Combine 
PROBLEMS=1
if [ "$STOPPEDQUEUE" -eq 0 ] && [ "$TXPATHHANG" -eq 0 ]; then
	PROBLEMS=0
	logg "No problem indicators observed."
fi


################################################################################
# Check client connections (client lost)
################################################################################

# Check if there are connected clients to this node
CLIENTCONNECTIONS=0
PIPE=$(mktemp -u -t workaround-pipe-XXXXXX)
# check for clients on each wifi device
mkfifo $PIPE
iw dev | grep Interface | cut -d" " -f2 > $PIPE &
while read wifidev; do
	iw dev $wifidev station dump 2>/dev/null | grep -q Station
	if [ $? -eq 0 ]; then
		CLIENTCONNECTIONS=1
		logg "Found wifi clients."
		break
	fi
done < $PIPE
rm $PIPE


# Remember if there were client connections after the last wifi restart or reboot
CLIENTFILE="/tmp/wifi-connection-active"
if [ ! -f "$CLIENTFILE" ] && [ "$CLIENTCONNECTIONS" -eq 1 ]; then
	logg "There are wifi connections after a previous boot or wifi restart."
	touch $CLIENTFILE
fi

################################################################################
# Check mesh connection (mesh lost)
################################################################################

# Check for an active ibss0 mesh
MESHCONNECTIONS=0
if iw dev ibss0 station dump | grep Station
then
 MESHCONNECTIONS=1
 logg "Found a wifi mesh."
fi

# Remember if there were mesh connections after the last wifi restart or reboot
MESHFILE="/tmp/wifi-mesh-connections-active"
if [ ! -f "$MESHFILE" ] && [ "$MESHCONNECTIONS" -eq 1 ]; then
	logg "There are mesh connections after a previous boot or wifi restart."
	touch $MESHFILE
fi

################################################################################
# Check gateway connection (uplink lost)
################################################################################

# Try to ping the default gateway (mainly for wifi mesh only nodes needed)
GWCONNECTION=0
GATEWAY=$(batctl gwl | grep "^=>" | awk -F'[ ]' '{print $2}')
if [ $GATEWAY ]; then
	batctl ping -c 5 $GATEWAY
	if [ $? -eq 0 ]; then
		GWCONNECTION=1
		logg "Ping default gateway $GATEWAY ... Okay!"
	else
		logg "Can't ping default gateway $GATEWAY."
	fi
else
	logg "Default gateway not found."
fi

# Remember if the defaultgatewy was pingable after the last wifi restart or reboot
# Important for only mesh clowd networking 
GWFILE="/tmp/gateway-connections-active"
if [ ! -f "$GWFILE" ] && [ "$GWCONNECTION" -eq 1 ]; then
	logg "There are default gateway connections after a previous boot or wifi restart."
	touch $GWFILE
fi

################################################################################
# Main wifi restart logik
################################################################################

WIFIRESTART=0

# Client & Errors (hier ist die Logik noch irgendwie unstimmig)
if [ -f "$CLIENTFILE" ] && [ "$CLIENTCONNECTIONS" -eq 0 ] && [ "$PROBLEMS" -eq 1 ]; then
	# There were lient connections before, but there are none at the moment and there are problem indicators.
	WIFIRESTART=1
	to_wifilog "/tmp/log/wifi-restart-reason-client-queue${STOPPEDQUEUE}-tph${TXPATHHANG}"
	logg "There were client connections before, but they vanished."
fi

# Mesh 
if [ -f "$MESHFILE" ] && [ "$MESHCONNECTIONS" -eq 0 ]; then
	# There were mesh connections before, but there are none at the moment.
	WIFIRESTART=1
	to_wifilog "/tmp/log/wifi-restart-reason-mesh"
	logg "There were mesh connections before, but they vanished."
fi

# No pingable default gateway.
if [ -f "$GWFILE" ] && [ $GWCONNECTION -eq 0 ]; then
	WIFIRESTART=1
	to_wifilog "/tmp/log/wifi-restart-reasons-gateway-ping"
	logg "No connection to the default gateway."
fi 


################################################################################
# Should I really do it?
################################################################################

if [ $WIFIRESTART -eq 1 ]; then    
	echo "Wifi restarted."
	logger "$LPREFIX: Wifi restarted."
	rm -rf $MESHFILE
	rm -rf $CLIENTFILE
	rm -rf $GWFILE
	touch $WAITFILE
	/sbin/wifi
else
	logg "Everything seems to be ok."
fi
