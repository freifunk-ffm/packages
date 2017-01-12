include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-button-bind
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  MAINTAINER:=Freifunk Frankfurt
  TITLE:=Button feature set binding
  DEPENDS:=+gluon-luci-admin
endef

define Package/gluon-legacy/description
	Bind a router button to a feature set.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,ffffm-button-bind,i18n)
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	$(call GluonInstallI18N,ffffm-button-bind,$(1))
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

