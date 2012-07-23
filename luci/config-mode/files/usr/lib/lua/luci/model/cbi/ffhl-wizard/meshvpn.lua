local uci = luci.model.uci.cursor()

local nav = require "luci.tools.ffhl-wizard.nav"

local f = SimpleForm("meshvpn", "Mesh-VPN", "Um deinen Freifunkknoten auch über das Internet mit anderen Knoten zu verbinden, muss das Mesh-VPN aktiviert werden.</p><p>Dadurch ist es möglich das Freifunknetz  auch ohne WLAN Verbindung zu anderen Knoten zu nutzen.")
f.template = "ffhl-wizard/wizardform"

meshvpn = f:field(Flag, "meshvpn", "Mesh-VPN aktivieren?")
meshvpn.default = string.format("%d", uci:get("fastd", "ffhl_mesh_vpn", "enabled"))
meshvpn.rmempty = false

upstream = f:field(Value, "upstream", "Upstream bandwidth (kbit/s)")
upstream.default = uci:get("ffhl", "bandwidth", "upstream")
downstream = f:field(Value, "dowstream", "Downstream bandwidth (kbit/s)")
downstream.default = uci:get("ffhl", "bandwidth", "downstream")

function f.handle(self, state, data)
	if state == FORM_VALID then
		local stat = false	
		uci:set("fastd", "ffhl_mesh_vpn", "enabled", data.meshvpn)
		uci:save("fastd")
		uci:commit("fastd")

		uci:set("ffhl", "bandwidth", "upstream", data.upstream)
		uci:set("ffhl", "bandwidth", "downstream", data.downstream)
		
		if data.meshvpn == "1" then
      local secret = uci:get("fastd", "ffhl_mesh_vpn", "secret")
      if not secret or not secret:match("%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x") then 
	  		luci.sys.call("/etc/init.d/haveged start")
  			local f = io.popen("fastd --generate-key --machine-readable", "r")
		  	local secret = f:read("*a")
	  		f:close()
  			luci.sys.call("/etc/init.d/haveged stop")

			  uci:set("fastd", "ffhl_mesh_vpn", "secret", secret)
		  	uci:save("fastd")
	  		uci:commit("fastd")
			
      end
			luci.http.redirect(luci.dispatcher.build_url("wizard", "meshvpn", "pubkey"))
		else
			nav.maybe_redirect_to_successor()
		end
	end
	
	return true
end

return f