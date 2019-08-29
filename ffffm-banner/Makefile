include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-banner
PKG_VERSION:=2.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=ffffm
  CATEGORY:=Customization
  TITLE:=Banner file replacement
  DEPENDS:=+busybox
  MAINTAINER:=Freifunk Frankfurt <admin@ffm.freifunk.net>
endef

define Package/ffffm-banner/description
	A banner file replacement
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
