#!/bin/sh

logg() {
DEBBUG=1
PREFIX="ath9k-broken-wifi-workaround"
echo "$PREFIX: $1"
if [ $DEBBUG -eq 1 ]; then
	logger "$PREFIX: $1"
fi
}

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

# Checkn autoupdater process 
pgrep autoupdater >/dev/null
if [ "$?" == "0" ]; then
	logg "Autoupdater is running, aborting."
	exit
fi

# Check if the TX queue is stopped
STOPPEDQUEUE=0
if [ "$(grep BE /sys/kernel/debug/ieee80211/phy0/ath9k/queues | cut -d":" -f7 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	STOPPEDQUEUE=1
	logg "Observed a stopped queue, continuing."
fi

# Check calibration errors
CALIBERRORS=0
if [ "$(grep Calibration /sys/kernel/debug/ieee80211/phy0/ath9k/reset | cut -d":" -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	CALIBERRORS=1
	logg "Observed a calibration error, continuing."
fi

# Check TX Path Hangs
TXPATHHANG=0
if [ "$(grep "TX Path Hang" /sys/kernel/debug/ieee80211/phy0/ath9k/reset | cut -d":" -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	TXPATHHANG=1
	logg "Observed a TX Path Hang, continuing."
fi

# Compine all
PROBLEMS=1
if [ "$STOPPEDQUEUE" -eq 0 ] && [ "$CALIBERRORS" -eq 0 ] && [ "$TXPATHHANG" -eq 0 ]; then
	PROBLEMS=0
	logg "No problem indicators observed."
fi

# check if there are connections to other nodes via wireless meshing
WIFICONNECTIONS=0
#batctl o | egrep -q "ibss0|mesh0"
#if [ "$?" == "0" ]; then
#	WIFICONNECTIONS=1
#	echo "Found wifi mesh partners."
#fi

# Try to ping the default gateway
GWCONNECTION=0
UPTIME=$(cat /proc/uptime | awk -F'[.]' '{print $1}')
SECWAIT="300"
if [ $UPTIME -lt $SECWAIT ]; then
    logg "Device startup time not finished yet, continuing."
    logg "Uptime: $UPTIME"
    GWCONNECTION=1
else
	GATEWAY=$(batctl gwl | grep "^=>" | awk -F'[ ]' '{print $2}')
	if [ $GATEWAY ]; then
		batctl ping -c 10 $GATEWAY
		if [ $? -eq 0 ]; then
			GWCONNECTION=1
			logg "Ping the default gateway $GATEWAY, okay."
		else
			logg "Can't ping the default gateway $GATEWAY."
		fi
	else
		logg "Default gateway not found."
	fi
fi


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

TMPFILE="/tmp/log/wifi-connections-active"
# Remember if there were client connections after the last wifi restart or reboot
if [ ! -f "$TMPFILE" ] && [ "$CLIENTCONNECTIONS" -eq 1 ]; then
	logg "There are connections again after a previous boot or wifi restart."
	touch $TMPFILE
fi


# Wifi restart 
WIFIRESTART=0

if [ -f "$TMPFILE" ] && [ "$CLIENTCONNECTIONS" -eq 0 ] && [ "$PROBLEMS" -eq 1 ]; then
	# There were connections before, but there are none at the moment and there are problem indicators.
	WIFIRESTART=1
	echo "$(date +%Y-%m-%d:%H:%M)" >> /tmp/log/wifi-last-restart-reasons-calib${CALIBERRORS}-queue${STOPPEDQUEUE}-tph${TXPATHHANG}
	logg "There were connections before, but they vanished."
	rm $TMPFILE
fi
# Restart wifi, if there were no default gateway was found.
if [ $GWCONNECTION -eq 0 ]; then
	WIFIRESTART=1
	echo "$(date +%Y-%m-%d:%H:%M)" >> /tmp/log/wifi-last-restart-reasons-gateway-ping
	logg "No connection to the default gateway."
fi 
 
if [ $WIFIRESTART -eq 1 ]; then
	/sbin/wifi
	logg "Wifi restarted."
else
	logg "Everything seems to be ok."
fi
