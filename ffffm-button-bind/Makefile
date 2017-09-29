include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-button-bind
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  MAINTAINER:=Freifunk Frankfurt
  TITLE:=Button feature set binding
  DEPENDS:=+gluon-web-admin
endef

define Package/$(PKG_NAME)/description
	Bind a router button to a feature set.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GluonInstallI18N,$(PKG_NAME),$(1))
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
