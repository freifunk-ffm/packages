local uci = require("simple-uci").cursor()

local f = Form('Wifi-Taster')
local s = f:section(Section, nil, "Hat der Router einen Wifi-Taster, so kann diesem hier eine Funktion zugeordnet werden:")

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
o:value('3', "Nachtmodus 1: alle Status-LEDs an/aus")
o:value('4', "Nachtmodus 2: LEDs aus, aber während Taster-Betätigung an")
o:value('5', "Client-Netz an/aus")
o:value('6', "Mesh-VPN aus für 5 Stunden")

function o:write(data)
	uci:set('button-bind', 'wifi', 'function', data)
end

function f:write()
	uci:commit('button-bind')
end

return f
