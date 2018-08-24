include $(TOPDIR)/rules.mk

PKG_NAME:=nodealert
PKG_VERSION:=0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

CMAKE_OPTIONS:=-DINSTALL_TESTS=OFF

define Package/nodealert
	TITLE:=$(PKG_NAME)
	CATEGORY:=Network
	MAINTAINER:=christof.schulze@gmx.net
	DEPENDS:=+respondd +libuci
endef

define Package/nodealert/description
	allow to specify node-alert in respondd module
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/nodealert/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/lib/gluon/respondd
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/respondd-alert.so $(1)/lib/gluon/respondd/respondd-alert.so
endef

$(eval $(call BuildPackage,nodealert))
