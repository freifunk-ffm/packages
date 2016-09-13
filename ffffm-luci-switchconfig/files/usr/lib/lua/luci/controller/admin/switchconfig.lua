module("luci.controller.admin.switchconfig", package.seeall)

function index()
        entry({"admin", "switchconfig"}, cbi("admin/switchconfig"), _("VLAN on WAN"), 20)
end


