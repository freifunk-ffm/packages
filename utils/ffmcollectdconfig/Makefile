include $(TOPDIR)/rules.mk

PKG_NAME:=ffmcollectdconfig
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffmcollectdconfig
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=collectd client config for Frankfurt Net
  DEPENDS:=+collectd5
endef

define Package/ffmcollectdconfig/description
	configuration for collectd in Freifunk Frankfurt net:
	this package deploys a configuration for collectd. As workaround
	for a connection handling issue in collectd, the service is restarted
	by cron every two hours. This package deploys the cron-script 
	This is only useful for Freifunk Frankfurt
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffmcollectdconfig/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffmcollectdconfig))

