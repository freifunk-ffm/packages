#!/usr/bin/lua
local site = require 'gluon.site_config'
local dnsmasqconf = arg[1]

file = io.open(dnsmasqconf, "w")
file:write("# auto-generated config file from site.conf\n")
file:write("conf-file=/etc/dnsmasq.conf\n")
file:write("domain-needed\n")
file:write("localise-queries\n")
file:write("read-ethers\n")
file:write("bogus-priv\n")
file:write("expand-hosts\n")
file:write("no-poll\n")
file:write("local-service\n")
file:write("cache-size=" .. site.dns.cacheentries .. "\n")
for _, server in ipairs(site.dns.servers)
do
  file:write("server=/" .. server .. "\n")
end
file:write("resolv-file=/tmp/resolv.conf.auto\n")
file:write("addn-hosts=/tmp/hosts\n")
file:write("stop-dns-rebind\n")
file:write("rebind-localhost-ok\n")
file:write("no-dhcp-interface=br-wan\n")
file:write("no-dhcp-interface=br-client\n")
file:close()

