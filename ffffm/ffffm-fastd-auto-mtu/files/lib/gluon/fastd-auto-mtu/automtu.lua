#!/usr/bin/lua
local uci = require('luci.model.uci').cursor()

local fastd_mtu_low = '1280'
local fastd_mtu_high = '1426'
local DSL_mtu_high = '1492' - '28'

local result = fastd_mtu_low
local mtu

if not (uci:get('fastd','mesh_vpn','enabled') == '1') then
  os.execute('logger automtu: mesh_vpn not enabled.')
  os.exit()
end

if not (uci:get('fastd','mesh_vpn','auto_mtu_enabled') == '1') then
  os.execute('logger automtu: automtu not enabled.')
  os.exit()
end


function setMTU ( x )
  os.execute('logger automtu: fastd MTU changed')
  os.execute('logger automtu: restart fastd')
  print('fastd MTU changed')
  print('restart fastd...')
  uci:set('fastd', 'mesh_vpn', 'mtu', x)
  uci:save('fastd')
  uci:commit('fastd')
  os.execute('/etc/init.d/fastd restart')
  return x
end

local f = io.popen("/usr/bin/ping -M do -s " ..DSL_mtu_high.. " -c 5 8.8.8.8")
local o = f:read('*all')
f:close()

if o:find('5 packets transmitted') then
  if not o:find('100%% packet loss') then
    result=fastd_mtu_high
   end
end

mtu = uci:get('fastd', 'mesh_vpn', 'mtu')

if result == fastd_mtu_high then
  if not (mtu == fastd_mtu_high) then
    mtu = setMTU (fastd_mtu_high)
  end
else
  if not (mtu == fastd_mtu_low) then
    mtu = setMTU (fastd_mtu_low)
  end
end

print ('fastd MTU = ' .. mtu .. ' Byte')
os.execute('logger automtu: fastd MTU = ' .. mtu .. ' Byte')

