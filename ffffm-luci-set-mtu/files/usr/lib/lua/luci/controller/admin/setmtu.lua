module("luci.controller.admin.setmtu", package.seeall)

function index()
	entry({"admin", "setmtu"}, cbi("admin/setmtu"), "MTU", 20)
end

