#!/usr/bin/lua

local site = require 'gluon.site_config'
local uci = require('luci.model.uci').cursor()

local fastd_mtu_low = tostring(site.fastd_auto_mtu.mtu_fastd_low)
local fastd_mtu_high = tostring(site.fastd_auto_mtu.mtu_fastd_high)
local DSL_mtu = tostring(site.fastd_auto_mtu.mtu_uplink_max) - '28'
local ptarget = site.fastd_auto_mtu.ping_target
local delay = site.fastd_auto_mtu.delay_time
local wan_if = site.fastd_auto_mtu.wan_if

local result = fastd_mtu_low
local mtu = uci:get('fastd', 'mesh_vpn', 'mtu')

local f
local o

-- 
function setMTU ( x )
  os.execute('logger automtu: fastd MTU-Size changed')
  uci:set('fastd', 'mesh_vpn', 'mtu', x)
  uci:save('fastd')
  uci:commit('fastd')
  os.execute('logger automtu: Restart the network...')
  os.execute('/etc/init.d/fastd stop') 
  os.execute('/etc/init.d/network restart')
  os.execute('/etc/init.d/fastd start')
  return x
end

-- 
if not (uci:get('fastd','mesh_vpn','enabled') == '1') then
  os.execute('logger automtu: mesh_vpn not enabled.')
  os.exit()
end

if not (uci:get('fastd','mesh_vpn','auto_mtu_enabled') == '1') then
  os.execute('logger automtu: auto_mtu not enabled.')
  os.exit()
end

--
mtu = uci:get('fastd', 'mesh_vpn', 'mtu')
os.execute('logger automtu: Current fastd MTU = ' .. mtu .. ' Byte')
print ("mtu = " .. mtu)

--
os.execute('logger automtu: Check Up-Link...')
f = io.popen('/sbin/ifconfig ' .. wan_if)
o = f:read('*all')
f:close()
if not o:find('inet addr:') then
  os.execute('logger automtu: Up-Link not found yet. Wait...')
  os.execute('sleep ' .. delay)
end

--
os.execute('logger automtu: Start MTU-Check...')
f = io.popen('/usr/bin/ping -M do -s ' .. DSL_mtu .. ' -c 5 ' .. ptarget)
o = f:read('*all')
f:close()

if o:find('5 packets transmitted') then
  if not o:find('100%% packet loss') then
    result = fastd_mtu_high
  end
end

--
if result == fastd_mtu_high then
  if not (mtu == fastd_mtu_high) then
    mtu = setMTU (fastd_mtu_high)
  end
else
  if not (mtu == fastd_mtu_low) then
    mtu = setMTU (fastd_mtu_low)
  end
end

--
os.execute('logger automtu: New fastd MTU = ' .. mtu .. ' Byte')
