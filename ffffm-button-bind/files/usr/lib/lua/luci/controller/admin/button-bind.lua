module("luci.controller.admin.button-bind", package.seeall)
function index()
        entry({"admin", "button-bind"}, cbi("admin/button-bind"), _("Button Bind"), 85)
end
