local uci = luci.model.uci.cursor()

local f, s, o, fct

f = SimpleForm('button-bind', "Taster")
f.template = 'admin/expertmode'
s = f:section(SimpleSection, nil, "Hier können einzelnen Router-Tastern unterschiedliche Funktionalitäten zugeordnet werden.")

-- Sollen mehrere Taser konfiguriert werden, dann einfach folgendes Schemata vervielfaeltigen:
fct = uci:get('button-bind', 'wifi', 'function')
if not fct then
fct='0'
end
o = s:option(ListValue, "wifi", "Wifi ON/OFF")
o.default = fct
o.widget = "radio"
o.rmempty = false
o:value('0', "Taster schaltet das WLAN an/aus (z.Z. noch Grundeinstellung).")
o:value('1', "Taster hat keine Funktion.")
o:value('2', "Taster führt einen WLAN-Reset aus.")
o:value('3', "Während der Tasterbetätigung werden in diesem Modus die dann generell abgeschalteten Status-LED zugeschaltet. Nach der Tasterbetätigung werden die Status-LED wieder abgeschaltet.")
function f.handle(self, state, data)
	if state == FORM_VALID then
		uci:set('button-bind', 'wifi', 'function', data.wifi)
		uci:commit('button-bind')
	end
end

return f
