#!/usr/bin/lua

local uci = require('luci.model.uci').cursor()

local fastd_mtu_low = '1280'
local fastd_mtu_high = '1426'
local DSL_mtu_high = '1492' - '28'
local ptarget = '8.8.8.8'

local result = fastd_mtu_low
local wan_if = 'br-wan'
local delay = '10'
local mtu

local f
local o

-- 
function setMTU ( x )
  os.execute('logger automtu: new fastd MTU saved')
  uci:set('fastd', 'mesh_vpn', 'mtu', x)
  uci:save('fastd')
  uci:commit('fastd')
  os.execute('logger automtu: please reboot your device to activate the new MTU-Size...')
  return x
end

--
print('Fuer eine Ausgabe bitte "logread -f" auf einer anderen Konsole starten.')

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
os.execute('logger automtu: current fastd MTU = ' .. mtu .. ' Byte')

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
f = io.popen('/usr/bin/ping -M do -s ' .. DSL_mtu_high .. ' -c 5 ' .. ptarget)
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
    mtu = setMTU (fastd_mtu_high, uplink)
  end
else
  if not (mtu == fastd_mtu_low) then
    mtu = setMTU (fastd_mtu_low, uplink)
  end
end

--
os.execute('logger automtu: new fastd MTU = ' .. mtu .. ' Byte')
