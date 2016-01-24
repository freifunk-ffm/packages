local f, s, o
local site = require 'gluon.site_config'
local i18n = require "luci.i18n"
local uci = luci.model.uci.cursor()
local config = 'fastd'

-- where to read the configuration from
local mtu = uci:get(config, "mesh_vpn", "mtu")

f = SimpleForm("mtu", i18n.translate("MTU-Config-Titel"))
f.template = "admin/expertmode"

s = f:section(SimpleSection, nil, i18n.translate("MTU-Config-Text"))

o = s:option(ListValue, "mtu", i18n.translate("MTU Block Size"))
o.default = mtu
o.rmempty = false
for _, mtu in ipairs(site.fastd_mesh_vpn.mtu_posible_size.list) do
  o:value(mtu, i18n.translate('ffffm-luci-set-mtu:mtu_size:' .. mtu))
end

function f.handle(self, state, data)
  if state == FORM_VALID then
    uci:set(config, "mesh_vpn", "mtu", data.mtu)

    uci:save(config)
    uci:commit(config)
  end
end

return f
