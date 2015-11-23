#!/bin/sh

if [ $1 == '1426' ]; then
  MTU=1426
  PORT=10000
else
  MTU=1280
  PORT=10001
fi

uci set fastd.mesh_vpn.mtu=$MTU

for i in $(seq 1 20); do
  echo fastd.mesh_vpn_backbone_peer_fastd$i.remote='ipv4 "fastd'$i'.ffm.freifunk.net" port '$PORT
  uci set fastd.mesh_vpn_backbone_peer_fastd$i.remote='ipv4 "fastd'$i'.ffm.freifunk.net" port '$PORT
  if [ $2 ]; then
    echo fastd.mesh_vpn_backbone_peer_fastd$i.enabled='0'
    uci set fastd.mesh_vpn_backbone_peer_fastd$i.enabled='0'
  else
    echo fastd.mesh_vpn_backbone_peer_fastd$i.enabled='1'
    uci set fastd.mesh_vpn_backbone_peer_fastd$i.enabled='1'
  fi
  echo
done

echo
echo
echo MTU = $MTU
echo PORT = $PORT
echo

if [ $2 ]; then
  echo fastd.mesh_vpn_backbone_peer_fastd$2.enabled='1'
  uci set fastd.mesh_vpn_backbone_peer_fastd$2.enabled='1'
  echo uci set fastd.mesh_vpn_backbone.peer_limit='1'
  uci set fastd.mesh_vpn_backbone.peer_limit='1'
else
  echo uci set fastd.mesh_vpn_backbone.peer_limit='2'
  uci set fastd.mesh_vpn_backbone.peer_limit='2'
fi

echo 
echo Starte fastd neu

/etc/init.d/fastd restart
