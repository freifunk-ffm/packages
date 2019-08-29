include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-helper-tools
PKG_VERSION:=1.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=ffffm
  CATEGORY:=Customization
  TITLE:=Small helper toolbox
  DEPENDS:=+gluon-core +busybox
  MAINTAINER:=Freifunk Frankfurt <admin@ffm.freifunk.net>
endef

define Package/ffffm-banner/description
	A small local helper toolbox
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
