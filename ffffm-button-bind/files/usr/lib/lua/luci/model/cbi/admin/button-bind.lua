local f, s, o
local site = require 'gluon.site_config'
local i18n = require 'luci.i18n'
local uci = luci.model.uci.cursor()

f = SimpleForm('Button-Bind', i18n.translate('Button-Bind-Config-Titel'))
f.template = 'admin/expertmode'

s = f:section(SimpleSection, nil, i18n.translate('Button-Bind-Text'))

-- https://github.com/openwrt/luci/blob/master/documentation/CBI.md

o = s:option(ListValue, "wifi", i18n.translate('WiFi Button'))
o.default = '0'
o.widget = "radio"
o.rmempty = false
o:value('0', "Taster hat keine Funktion. (Grundeinstellung)")
o:value('1', "Taster schaltet das WLAN an/aus. (OpenWrt-Funktionalitaet)")
o:value('2', "Taster schaltet nur das Client-WLAN an/aus.")
o:value('3', "Waehrend der Tasterbetaetigung werden in diesem Modus die generell abgeschalteten Status-LED zugeschaltet. Nach der Tasterbetaetigung werden die Status-LED wieder abgeschaltet.")

o = s:option(ListValue, "reset", i18n.translate("Reset Button"))
o.default = '0'
o.widget = "radio"
o.rmempty = false
o:value('0', "Taster hat bekannte Gluon-Funktionalitaet. (Grundeinstellung)")
o:value('1', "Taster hat keine Funktion.")

function f.handle(self, state, data)
	if state == FORM_VALID then
		if data.wifi == '0' then
		else
		end
		if data.reset == '0' then
		else
		end
	end
end

return f 
