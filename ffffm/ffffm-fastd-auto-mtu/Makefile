include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-fastd-auto-mtu
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffffm-fastd-auto-mtu
  SECTION:=ffffm
  CATEGORY:=Gluon
  TITLE:=Auto-select the mtu for mesh-vpn based on local Internet uplink
  DEPENDS:=+gluon-core +gluon-mesh-vpn-fastd +iputils-ping
  MAINTAINER:=Freifunk Frankfurt <admin@ffm.freifunk.net>
  URL:=https://github.com/freifunk-gluon/packages
  SOURCE:=https://github.com/freifunk-gluon/packages
endef

define Package/ffffm-fastd-auto-mtu/description
	This package will check the MTU using ping and select between 1280 and 1426 for the interface mesh-vpn
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-fastd-auto-mtu/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-fastd-auto-mtu))
