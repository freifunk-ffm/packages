module("luci.controller.admin.button-bind", package.seeall)
function index()
        entry({"admin", "button-bind"}, cbi("admin/button-bind"), "Taster", 85)
end
