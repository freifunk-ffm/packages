module("luci.controller.admin.button-bind", package.seeall)
function index()
        entry({"admin", "button-bind"}, cbi("admin/button-bind"), "Tasten", 85)
end
