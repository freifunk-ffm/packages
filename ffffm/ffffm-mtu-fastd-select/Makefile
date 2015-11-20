include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-mtu-fastd-select
PKG_VERSION:=1
PKG_RELEASE:=$(GLUON_VERSION).$(GLUON_SITE_CODE)-$(GLUON_RELEASE).$(GLUON_CONFIG_VERSION)

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffffm-mtu-fastd-select
  SECTION:=ffffm
  CATEGORY:=Gluon
  TITLE:=Auto-select the mtu for mesh-vpn based on local Internet uplink
  DEPENDS:=+gluon-core
  MAINTAINER:=Freifunk Frankfurt <admin@ffm.freifunk.net>
  URL:=https://github.com/freifunk-gluon/packages
  SOURCE:=https://github.com/freifunk-gluon/packages
endef

define Package/ffffm-mtu-fastd-select/description
	This package will check the mtu using tracerout and select between 1280 and 1426 for the interface mesh-vpn
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-ebtables-net-rules/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-ebtables-net-rules))
