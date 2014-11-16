local uci = luci.model.uci.cursor()
local sysconfig = require 'gluon.sysconfig'
local platform = require 'gluon.platform'

local f = SimpleForm("switchconfig", "WAN-Verbindung")
f.template = "admin/expertmode"
f.submit = "Speichern"
f.reset = "Zurücksetzen"

local s
local o
local svlanname = "switch-wanvlan"
local configsection = uci:get_first("vlan_wan", "general")

s = f:section(SimpleSection, nil, nil)
o = s:option(Flag, "vlan_wan", "VLAN auf WAN-Port aktivieren")

o.default = uci:get_bool("vlan_wan", configsection, "active") and o.enabled or o.disabled
o.rmempty = false
o = s:option(Value, "vlan_id", "VLAN ID")
o:depends("vlan_wan", "1")
o.value = uci:get("vlan_wan", configsection, "vlan") and uci:get("vlan_wan", configsection, "vlan") or 42
o.datatype = "integer"
o.rmempty = false

function prunevlanconfig(s)
  --os.execute("logger section: " .. tostring(s) .. " " .. s[".name"]    )
  --os.execute("logger " .. tostring(uci:get("network", s[".name"],"name")))
  if uci:get("network", s[".name"],"name") == svlanname then
    uci:delete("network", s[".name"])
  end
end

function f.handle(self, state, data)
  local configsection

  if state == FORM_VALID then
    if data.vlan_wan == '1' then
      if not  platform.match('ar71xx', 'generic', { 'tl-wdr4300', 'tl-wr741nd-v4', 'tl-wr841n-v8', 'tl-wr841nd-v8', 'tl-wr841nd-v9' } ) then
	os.execute("logger ERROR: no vlan-on-wan compatible platform found. Write an email to info@ffm.freifunk.net and post the content of /tmp/sysinfo/board_name, the exact router Model and uci show|grep network  ")
	os.execute("logger ERROR: no vlan-on-wan compatible device found - configuration will not be changed.")
	return true
      end
      
      local configsection = uci:get_first("vlan_wan", "general")

      if uci:get("vlan_wan", configsection , "active") == nil then 
	local f = io.open('/etc/config/vlan_wan', 'w')
	f:write('')
	f:close()
	configsection=uci:add("vlan_wan", "general")
      end
      os.execute("logger bool - active? wert aus vlan_wan " ..  tostring(uci:get("vlan_wan", configsection, "active") ))
      if not uci:get_bool("vlan_wan", configsection, "active") then 
	uci:set("vlan_wan", configsection, "active", '1')
      end
      uci:set("vlan_wan", configsection, "vlan", data.vlan_id)
      uci:save("vlan_wan")
      uci:commit("vlan_wan")
      local device
      os.execute("logger see /tmp/sysinfo/board_name check if platform matches ")

      uci:foreach("network","switch_vlan", prunevlanconfig) 
      local section = uci:add("network", "switch_vlan")
      uci:set("network",section, "name", svlanname)
      uci:set("network",section, "vlan", data.vlan_id)
      if platform.match('ar71xx', 'generic', { 'tl-wr741nd-v4', 'tl-wr841n-v8', 'tl-wr841nd-v8', 'tl-wr841nd-v9' } ) then
	device = sysconfig.wan_ifname
	-- see /tmp/sysinfo/board_name
      elseif platform.match('ar71xx', 'generic', { 'tl-wdr4300', 'tl-wdr3600' } ) then
	device=string.sub(sysconfig.wan_ifname, 0, string.find(sysconfig.wan_ifname, "%.") -1)
        uci:set("network",section, "device", "switch0")
        uci:set("network",section, "ports", "0t 1t")
      end
      uci:set("network", "wan" , "ifname", device .. '.' .. data.vlan_id)
    else
      -- reset wan nic
      uci:set("network","wan", "ifname", sysconfig.wan_ifname )
    end

    uci:save("network")
    uci:commit("network")
  end

  return true
end

return f

