include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-button-bind
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

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
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
