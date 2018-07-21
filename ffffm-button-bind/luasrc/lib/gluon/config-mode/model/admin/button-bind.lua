local uci = require("simple-uci").cursor()

local f = Form('Taster')
local s = f:section(Section, nil, "Hier können dem Router-Taster unterschiedliche Funktionalitäten zugeordnet werden.")


-- Sollen mehrere Taster konfiguriert werden, dann einfach folgendes Schemata vervielfaeltigen:

local fct = uci:get('button-bind', 'wifi', 'function')
if not fct then
	fct='0'
	uci:set('button-bind', 'wifi', 'button')
	uci:set('button-bind', 'wifi', 'function', fct)
	uci:commit('button-bind')
end
local o = s:option(ListValue, "wifi", "Wifi ON/OFF Taster")
o.default = fct
o:value('0', "Wifi an/aus (default)")
o:value('1', "Funktionslos")
o:value('2', "Wifi-Reset")
o:value('3', "Nachtmodus - LEDs aus, an bei Betätigung")

function o:write(data)
	uci:set('button-bind', 'wifi', 'function', data)
end

function f:write()
	uci:commit('button-bind')
end

return f


