local uci = require("simple-uci").cursor()

local f = Form('Taster')
local s = f:section(Section, nil, "Hat der Router eine Wifi-Taste, so können dieser Taste unterschiedliche Funktionalitäten zugeordnet werden.")


-- Sollen mehrere Taster konfiguriert werden, dann einfach folgendes Schemata vervielfaeltigen:

local fct = uci:get('button-bind', 'wifi', 'function')
if not fct then
	fct='1'
	uci:set('button-bind', 'wifi', 'button')
	uci:set('button-bind', 'wifi', 'function', fct)
	uci:commit('button-bind')
end
local o = s:option(ListValue, "wifi", "Wifi ON/OFF Taster")
o.default = fct
o:value('0', "Wifi an/aus")
o:value('1', "Funktionslos (default)")
o:value('2', "Wifi-Reset")
o:value('3', "Nachtmodus - LEDs aus, aber während Taster-Betätigung an")

function o:write(data)
	uci:set('button-bind', 'wifi', 'function', data)
end

function f:write()
	uci:commit('button-bind')
end

return f


