#!/bin/sh
# check if node has wifi
if [ ! -L /sys/class/ieee80211/phy0/device/driver ] && [ ! -L /sys/class/ieee80211/phy1/device/driver ]; then
	echo "node has no wifi, aborting."
	exit
fi
# check if node uses ath9k wifi driver
if ! expr "$(readlink /sys/class/ieee80211/phy0/device/driver)" : ".*/ath9k" >/dev/null; then
	if ! expr "$(readlink /sys/class/ieee80211/phy1/device/driver)" : ".*/ath9k" >/dev/null; then
		echo "node doesn't use the ath9k wifi driver, aborting."
		exit
	fi
fi
# don't do anything while an autoupdater process is running
pgrep autoupdater >/dev/null
if [ "$?" == "0" ]; then
	echo "autoupdater is running, aborting."
	exit
fi
# check if the queue is stopped because it got full
STOPPEDQUEUE=0
if [ "$(grep BE /sys/kernel/debug/ieee80211/phy0/ath9k/queues | cut -d":" -f7 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	STOPPEDQUEUE=1
	echo "observed a stopped queue. continuing."
fi
# check if there are calibration errors
CALIBERRORS=0
if [ "$(grep Calibration /sys/kernel/debug/ieee80211/phy0/ath9k/reset | cut -d":" -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	CALIBERRORS=1
	echo "observed a calibration error. continuing."
fi
# check if there are TX Path Hangs
TXPATHHANG=0
if [ "$(grep "TX Path Hang" /sys/kernel/debug/ieee80211/phy0/ath9k/reset | cut -d":" -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" -ne 0 ]; then
	TXPATHHANG=1
	echo "observed a TX Path Hang. continuing."
fi
# abort if none of the problem indicators appeared
PROBLEMS=1
if [ "$STOPPEDQUEUE" -eq 0 ] && [ "$CALIBERRORS" -eq 0 ] && [ "$TXPATHHANG" -eq 0 ]; then
	PROBLEMS=0
	echo "no problem indicators observed."
fi
WIFICONNECTIONS=0
# check if there are connections to other nodes via wireless meshing
batctl o | egrep -q "ibss0|mesh0"
if [ "$?" == "0" ]; then
	WIFICONNECTIONS=1
	echo "found wifi mesh partners."
else
	PIPE=$(mktemp -u -t workaround-pipe-XXXXXX)
	# check for clients on each wifi device
	mkfifo $PIPE
	iw dev | grep Interface | cut -d" " -f2 > $PIPE &
	while read wifidev; do
		iw dev $wifidev station dump 2>/dev/null | grep -q Station
		if [ "$?" == "0" ]; then
			WIFICONNECTIONS=1
			echo "found wifi clients."
			break
		fi
	done < $PIPE
	rm $PIPE
fi
TMPFILE="/tmp/wifi-connections-active"
# restart wifi only, if there were connections after the last wifi restart or reboot and they vanished again
if [ ! -f "$TMPFILE" ] && [ "$WIFICONNECTIONS" -eq 1 ]; then
	echo "there are connections again after a previous boot or wifi restart, creating tempfile."
	touch $TMPFILE
elif [ -f "$TMPFILE" ] && [ "$WIFICONNECTIONS" -eq 0 ] && [ "$PROBLEMS" -eq 1 ]; then
	# there were connections before, but there are none at the moment and there are problem indicators
	wifi
	echo "$(date +%Y-%m-%d:%H:%M:%S)" > /tmp/wifi-last-restart-reasons-calib${CALIBERRORS}-queue${STOPPEDQUEUE}-tph${TXPATHHANG}
	echo "there were connections before, but they vanished. restarted wifi and deleting tempfile."
	rm $TMPFILE
else
	echo "everything seems to be ok."
fi
