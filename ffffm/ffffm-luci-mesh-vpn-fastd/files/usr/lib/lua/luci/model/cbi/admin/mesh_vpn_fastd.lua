local uci = luci.model.uci.cursor()
local util = luci.util

local f = SimpleForm('mesh_vpn', translate('Mesh VPN'))
f.template = "admin/expertmode"

local s = f:section(SimpleSection)

local o = s:option(Value, 'mtu')
o.template = "gluon/cbi/mesh-vpn-fastd-mode"

local mtu = uci:get('fastd', 'mesh_vpn', 'mtu')
if util.contains(mtu, '1426') then
  o.default = '1426'
else
  o.default = '1280'
end

function f.handle(self, state, data)
  if state == FORM_VALID then
    local site = require 'gluon.site_config'
local mtuval
    local methods = {}
    if data.mtu == '1426' then
	    mtuval = 1426
    else
	    mtuval = 1280
    end

    uci:set('fastd', 'mesh_vpn', 'mtu', mval)
    uci:save('fastd')
    uci:commit('fastd')
  end
end

return f
