local uci = luci.model.uci.cursor()

local f, s, o, fct

f = SimpleForm('button-bind', "Taster")
f.template = 'admin/expertmode'
s = f:section(SimpleSection, nil, "Hier können einzelnen Router-Tastern unterschiedliche Funktionalitäten zugeordnet werden.")

-- Sollen mehrere Taser konfiguriert werden, dann einfach folgendes Schemata vervielfaeltigen:
fct = uci:get('button-bind', 'wifi', 'function')
if not fct then
	fct='0'
	uci:set('button-bind', 'wifi', 'button')
	uci:set('button-bind', 'wifi', 'function', fct)
	uci:commit('button-bind')
end
o = s:option(ListValue, "wifi", "Wifi ON/OFF Taster")
o.default = fct
o.widget = "radio"
o.rmempty = false
o:value('0', "Wifi an/aus (z.Z. noch Grundeinstellung)")
o:value('1', "Funktionslos")
o:value('2', "Wifi-Reset")
o:value('3', "In diesem Modus sind die Status-LEDs generell deaktiviert. Während der Tasterbetätigung werden die Status-LEDs temporär aktiviert.")
-- Schemata Ende

function f.handle(self, state, data)
	if state == FORM_VALID then
		uci:set('button-bind', 'wifi', 'function', data.wifi)
		uci:commit('button-bind')
	end
end

return f
