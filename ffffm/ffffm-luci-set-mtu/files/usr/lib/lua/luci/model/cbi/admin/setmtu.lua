local f, s, o
local site = require 'gluon.site_config'
local i18n = require 'luci.i18n'
local uci = luci.model.uci.cursor()
local config = 'fastd'

local mtu_low = site.fastd_auto_mtu.mtu_fastd_low
local mtu_high = site.fastd_auto_mtu.mtu_fastd_high

-- Auto or where to read the configuration from

if uci:get(config, 'mesh_vpn', 'auto_mtu_enabled') == '1' then
  mtu = 'auto'
else
  mtu = uci:get(config, 'mesh_vpn', 'mtu')
end

f = SimpleForm('mtu', i18n.translate('MTU-Config-Titel'))
f.template = 'admin/expertmode'

s = f:section(SimpleSection, nil, i18n.translate('MTU-Config-Text'))

o = s:option(ListValue, "mtu", i18n.translate('MTU Block Size'))
o.default = mtu
o.rmempty = false

o:value(mtu_low, mtu_low)
o:value(mtu_high, mtu_high) 
o:value('auto', i18n.translate('ffffm-luci-set-mtu:mtu_size:' .. 'auto'))

function f.handle(self, state, data)
  if state == FORM_VALID then
    if data.mtu == 'auto' then
      uci:set(config, 'mesh_vpn', 'auto_mtu_enabled', 1)
      uci:save(config)
      uci:commit(config)
    else
      uci:set(config, 'mesh_vpn', 'mtu', data.mtu)
      uci:set(config, 'mesh_vpn', 'auto_mtu_enabled', 0)
      uci:save(config)
      uci:commit(config)
    end   
  end
end

return f
