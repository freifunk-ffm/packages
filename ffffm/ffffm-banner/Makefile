include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-banner
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffffm-banner
  SECTION:=ffffm
  CATEGORY:=Customization
  TITLE:=Banner file replacement and help tool
  DEPENDS:=+gluon-core +busybox
  MAINTAINER:=Freifunk Frankfurt <admin@ffm.freifunk.net>
  URL:=https://github.com/freifunk-gluon/packages
  SOURCE:=https://github.com/freifunk-gluon/packages
endef

define Package/ffffm-banner/description
	Banner file replacement and help tool
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-banner/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-banner))
