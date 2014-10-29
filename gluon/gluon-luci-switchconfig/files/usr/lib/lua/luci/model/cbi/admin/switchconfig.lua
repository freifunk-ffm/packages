local uci = luci.model.uci.cursor()

local wan = uci:get_all("network", "wan")
local wan6 = uci:get_all("network", "wan6")
local dns = uci:get_first("gluon-wan-dnsmasq", "static")

local f = SimpleForm("switchconfig", "WAN-Verbindung")
f.template = "admin/expertmode"
f.submit = "Speichern"
f.reset = "Zurücksetzen"

local s
local o

s = f:section(SimpleSection, nil, nil)
o = s:option(Flag, "vlan_wan", "VLAN auf WAN-Port aktivieren")
o.default = uci:get_bool("network", "vlan_wan", "auto") and o.enabled or o.disabled
o.rmempty = false

o = s:option(Value, "vlan_id", "VLAN ID")
o:depends("vlan_wan", "true")
o.value = 42
o.datatype = "integer"
o.rmempty = false

function f.handle(self, state, data)
  if state == FORM_VALID then
    if data.vlan_wan == true then
      -- Algo: das, wasin br-wan steht irgendwo in uci sichern
      -- wenn ein ethX.Y Gerät drin steht, erstmal ignorieren. Das kann das
      -- script noch nciht
      -- wenn ein ethX Gerät drin steht, für dieses das VLAN einstellen
      uci:set("network", "wan", "ipaddr", data.ipv4_addr)
      uci:set("network", "wan", "netmask", data.ipv4_netmask)
      uci:set("network", "wan", "gateway", data.ipv4_gateway)
    else
      -- TODO: alten Bridge- Konfig-wert hier rein schreiben
      uci:delete("network", "wan", "ipaddr")
      uci:delete("network", "wan", "netmask")
      uci:delete("network", "wan", "gateway")
    end

    uci:set("network", "mesh_wan", "auto", data.mesh_wan)

    uci:save("network")
    uci:commit("network")

    if dns then
      if #data.dns > 0 then
        uci:set("gluon-wan-dnsmasq", dns, "server", data.dns)
      else
        uci:delete("gluon-wan-dnsmasq", dns, "server")
      end

      uci:save("gluon-wan-dnsmasq")
      uci:commit("gluon-wan-dnsmasq")
    end
  end

  return true
end

return f

