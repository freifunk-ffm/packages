local f, s, o, fct
local site = require 'gluon.site_config'
local i18n = require 'luci.i18n'
local uci = luci.model.uci.cursor()

f = SimpleForm('button-bind', i18n.translate('Titel'))
f.template = 'admin/expertmode'
s = f:section(SimpleSection, nil, i18n.translate('Text'))

-- Sollen mehrere Taser konfiguriert werden, dann einfach folgendes Schmeata vervielfaeltigen:
fct = uci:get('button-bind', 'wifi', 'function')
if not fct then
fct='0'
end
o = s:option(ListValue, "wifi", i18n.translate('WiFi-on-off'))
o.default = fct
o.widget = "radio"
o.rmempty = false
o:value('0', i18n.translate('fct_0'))
o:value('1', i18n.translate('fct_1'))
o:value('2', i18n.translate('fct_2'))
o:value('3', i18n.translate('fct_3'))
function f.handle(self, state, data)
	if state == FORM_VALID then
		uci:set('button-bind', 'wifi', 'function', data.wifi)
		uci:commit('button-bind')
	end
end

return f
