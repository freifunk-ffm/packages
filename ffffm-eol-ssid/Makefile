# This package is based on https://gitlab.karlsruhe.freifunk.net/firmware/packages/-/tree/master/ffka-eol-ssid by Julian Schuh and Simon Terzenbach
include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-eol-ssid
PKG_VERSION:=1
PKG_RELEASE:=1

include $(TOPDIR)/../package/gluon.mk

define Package/ffffm-eol-ssid
  TITLE:=ffffm-eol-ssid
  DEPENDS:=+gluon-core
endef

$(eval $(call BuildPackageGluon,ffffm-eol-ssid))
