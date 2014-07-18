include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ffmautokey
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-ffmautokey
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=automatic key upload for fastd
  DEPENDS:=+fastd
endef

define Package/gluon-ffmautokey/description
	fastd automatic key upload:
	this package makes use of an on-up-script for fastd
	to upload the public key of fastd to a web application
	This is only useful for Freifunk Frankfurt
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-ffmautokey/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-ffmautokey))

