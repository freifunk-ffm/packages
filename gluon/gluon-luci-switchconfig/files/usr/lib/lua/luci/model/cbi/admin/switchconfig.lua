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
      os.execute("logger plattform match " .. tostring(platform.match('ar71xx', 'generic', { 'tl-wr741nd-v4'} )) )
      if platform.match('ar71xx', 'generic', { 'tl-wr741nd-v4', 'tl-wr841nd-v9' } ) then
	-- setze vlan
	local section
	local s = uci:foreach("network","switch_vlan", prunevlanconfig) 
	section = uci:add("network", "switch_vlan")
	uci:set("network",section, "name", svlanname)
	uci:set("network",section, "vlan", data.vlan_id)
	uci:set("network", "wan" , "ifname", sysconfig.wan_ifname .. '.' .. data.vlan_id)
	-- see /tmp/sysinfo/board_name
	elseif platform.match('ar71xx', 'generic', { 'tl-wdr4300nd-v1' } ) then
	-- TODO hier die wdr4300/3600 konfiguration aufnehmen.
      end
    else
      uci:set("network","wan", "ifname", sysconfig.wan_ifname )
    end

    uci:save("network")
    uci:commit("network")
  end

  return true
end

return f

