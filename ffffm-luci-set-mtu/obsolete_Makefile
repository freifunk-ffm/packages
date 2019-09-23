include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-luci-set-mtu
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)

define Package/ffffm-luci-set-mtu
  SECTION:=ffffm
  CATEGORY:=Gluon
  DEPENDS:=+gluon-luci-admin +gluon-mesh-vpn-fastd +ffffm-fastd-auto-mtu
  TITLE:=GUI for specifying MTU settings
  MAINTAINER:=Freifunk Frankfurt <admin@ffm.freifunk.net>
  URL:=https://github.com/freifunk-gluon/packages
  SOURCE:=https://github.com/freifunk-gluon/packages
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,ffffm-luci-set-mtu,i18n)
endef

define Package/ffffm-luci-set-mtu/install
	$(CP) ./files/* $(1)/
	$(call GluonInstallI18N,ffffm-luci-set-mtu,$(1))
endef

define Package/ffffm-luci-set-mtu/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,ffffm-luci-set-mtu))
