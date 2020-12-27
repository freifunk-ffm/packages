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
# 1) Ueberpruefen, ob ueberhaupt ein Problemtest durchgefuehrt werden kann/darf/soll.
# 2) Ueberpruefen ob eine Gateway/UpLink Verbindung besteht und dieses merken.
# 3) Auswerten ueber die Zeit von Gateway/UpLink.
# 4) Ueberpruefung von auffaelligen dmesg-Logeintraegen
# 5) Tritt ein Probleme erstmalig auf, dann ist der erste Loesungsversuch ein iw-Scan. 
#    Dieser Scan behebt im ersten Schritt einfachere Treiber-Probleme.
# 6) Traten innerhalb von zwei Skript-Aufrufzyklen Probleme auf, dann -> Wifi-Restart.
#
# Ausgabe:
# Es werden Ereignisse in die eigens definierte Logdatei /tmp/log/wifi-problem-timestamps
# und im Systemlog eingetragen.
#
######################################################################################


######################################################################################
#
# Zum Debuggen und zum selber Rumbasteln einfach die "#" vor allen "systemlog XYZ" entfernen
#
######################################################################################


######################################################################################
# Alle Kommentarzeilen werden durch das Makefile des Packages entfernt
# sed -i '/^# /d' ath9k-broken-wifi-workaround.sh
# sed -i '/^##/d' ath9k-broken-wifi-workaround.sh
#
######################################################################################

MESHFILE="/tmp/ath9k-wifi-mesh-connect"
GWFILE="/tmp/ath9k-wifi-gateway-connect"

RESTARTFILE="/tmp/ath9k-wifi-restart-pending"


######################################################################################
# Locale functions
######################################################################################

LOGFILE="/tmp/log/ath9k-wifi-problem-timestamps"
LPREFIX="ath9k-broken-wifi-workaround"

# Writes to the system log file
systemlog() {
logger -s -t "ath9k-workaround" -p 5 "$LPREFIX: $1"
}

# Writes to an own logfile in /tmp/log and to the systemlog as well
# Ringbuffer, limit own log file to MAX_LINES
multilog() {
MAX_LINES=22
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

# Don't run this script if another instance is still running
LOCKFILE="/var/lock/ath9k-broken-wifi-workaround.lock"
cleanup() {
# 	systemlog "cleanup, removing lockfile: $LOCKFILE"
	rm -f "$LOCKFILE"
	exit
}
if [ ! -f "$LOCKFILE" ]; then
	trap cleanup EXIT INT TERM
	touch "$LOCKFILE"
else
	multilog "Another instance is still running, aborting."
	exit
fi

#######################################################################################
# Check autoupdater
#######################################################################################
pgrep autoupdater >/dev/null
if [ "$?" == "0" ]; then
# 	systemlog "Autoupdater is running, aborting"
	exit
fi

#######################################################################################
# Check Outdoor-Mode (wegen gleichzeitigem DSF-Scan in Kombination mit einem 'wifi')
#######################################################################################
if [ "$(uci -q get gluon.wireless.outdoor)" == "1" ] ; then
# 	systemlog "Node is an outdoor device, aborting"
exit
fi

#######################################################################################
# Check if node has wifi
#######################################################################################
if [ "$(ls -l /sys/class/ieee80211/phy* | wc -l)" -eq 0 ]; then
# 	systemlog "Node has no wifi, aborting"
	exit
fi

#######################################################################################
# Check if node uses ath9k wifi driver
#######################################################################################
for i in $(ls /sys/class/net/); do
	if expr "$(readlink /sys/class/net/$i/device/driver)" : ".*/ath9k" >/dev/null; then
# 		gather a list of interfaces
		if [ -n "$ATH9K_IFS" ]; then
			ATH9K_IFS="$ATH9K_IFS $i"
		else
			ATH9K_IFS="$i"
		fi
# 		gather a list of devices
		if expr "$i" : "\(client\|mesh\)[0-1]" >/dev/null; then
			ATH9K_UCI="$(uci show wireless | grep $i | cut -d"." -f1-2)"
			ATH9K_DEV="$(uci get ${ATH9K_UCI}.device)"
			if [ -n "$ATH9K_DEVS" ]; then
				if ! expr "$ATH9K_DEVS" : ".*${ATH9K_DEV}.*" >/dev/null; then
					ATH9K_DEVS="$ATH9K_DEVS $ATH9K_DEV"
				fi
			else
				ATH9K_DEVS="$ATH9K_DEV"
			fi
			ATH9K_UCI=
			ATH9K_DEV=
		fi
	fi
done

# check if the ath9k interface list is empty
if [ -z "$ATH9K_IFS" ] || [ -z "$ATH9K_DEVS" ]; then
# 	multilog "node doesn't use the ath9k wifi driver, aborting."
	exit
fi

#######################################################################################
# Observe the dmesg output
#######################################################################################
DMESG_ATH9K=0
if dmesg | grep AR_PHY_AGC_CONTROL
then
	DMESG_ATH9K=1
fi

# Bad ATH10K_PCI workaround.
# See https://forum.openwrt.org/t/ath10k-pci-0000-01-00-0-swba-overrun-on-vdev-0-skipped-old-beacon/5002
DMESG_ATH10K=0
if [ -d /sys/bus/pci/drivers/ath10k_pci ]; then
	if dmesg | grep ath10k_pci | grep 'SWBA overrun on vdev'
	then
		DMESG_ATH10K=1
	fi
fi

######################################################################################
# Check mesh connection (wifi mesh lost)
######################################################################################

# Check for an active mesh

MESHCONNECTION=0
for wifidev in $ATH9K_IFS; do
	if expr "$wifidev" : "\(mesh\)[0-1]" >/dev/null; then
		if [ "$(batctl o | egrep "$wifidev" | wc -l)" -gt 0 ]; then
			MESHCONNECTION=1
# 			systemlog "found wifi mesh partners."
			if [ ! -f "$MESHFILE" ]; then
				# create file so we can check later if there was a wifi mesh connection before
				touch $MESHFILE
			fi
			break
		fi
	fi
done

######################################################################################
# Check gateway connection (uplink lost)
######################################################################################

# Try to ping the default gateway (needed mainly for wifi mesh only nodes)
GWCONNECTION=0
GATEWAY=$(batctl gwl | grep -e "^=>" -e "^\*" | awk -F'[ ]' '{print $2}')
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
# else
# 	systemlog "No default gateway defined"
fi

######################################################################################
# Main wifi restart logik
######################################################################################

WIFIRESTART=0

# Wifi mesh lost. This separated check is just for safety reasons ( I saw a node with a broken ibss but with active clients).
if [ -f "$MESHFILE" ] && [ "$MESHCONNECTION" -eq 0 ]; then
# There were mesh connections before, but there are none at the moment.
	WIFIRESTART=1
	multilog "Wifi mesh lost"
fi


# No pingable default gateway.
if [ -f "$GWFILE" ] && [ $GWCONNECTION -eq 0 ]; then
	WIFIRESTART=1
	multilog "No path to the default gateway $GATEWAY"
fi

# Some ath9k chipset problems have occurred. Probably snake oil!
# if [ $PROBLEMS -eq 1 ]; then
# Yes, it is snaik oil        WIFIRESTART=1
#        multilog "Just an info: TX queue is stopped and TX path hangs"
# fi

# DMESG ath9k Problem
if [ $DMESG_ATH9K -eq 1 ]; then
	WIFIRESTART=1
	multilog "Found a dmesg ath9k-problem. Ring buffer cleared."
# clear the dmesg ring buffer
	dmesg -c
# Bei diesem Problem das Wifi sofort neustarten lassen
	touch $RESTARTFILE
fi

# DMESG ath10k Problem
if [ $DMESG_ATH10K -eq 1 ]; then
	WIFIRESTART=1
	multilog "Found a dmesg ath10k-problem. Ring buffer cleared."
# clear the dmesg ring buffer
	dmesg -c
# Bei diesem Problem das Wifi sofort neustarten lassen
	touch $RESTARTFILE
fi

######################################################################################
# Should I really do it?
######################################################################################

if [ "$WIFIRESTART" -eq 1 ] && [ ! -f "$RESTARTFILE" ]; then
	touch $RESTARTFILE
# 	Als ersten Behebungsversuch einen iw-Scan durchfuehren.
	for wifidev in $ATH9K_IFS; do
		/usr/sbin/iw dev $wifidev scan lowpri
	done
	multilog "Wifi restart is pending"
elif [ $WIFIRESTART -eq 1 ]; then
	multilog "*** Wifi restarted ***"
	rm -rf $MESHFILE
	rm -rf $GWFILE
	rm -rf $RESTARTFILE
# 	Jetzt ein Wifi-Treiber-Restart
# 	Daher erst ein 'iw scan' gefolgt von einem 'wifi'
	for wifidev in $ATH9K_IFS; do
		/usr/sbin/iw dev $wifidev scan
	done
	/sbin/wifi
else
# 	systemlog "Everything seems to be ok"
	rm -rf $RESTARTFILE
fi
