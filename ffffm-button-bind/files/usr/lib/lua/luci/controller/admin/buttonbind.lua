module("luci.controller.admin.buttonbind", package.seeall)
function index()
        entry({"admin", "buttonbind"}, cbi("admin/buttonbind"), _("Button Bind"), 85)
end
