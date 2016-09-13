include $(TOPDIR)/rules.mk

PKG_NAME:=babeldev
PKG_VERSION:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/jech/babeld.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
# this is master from jul 31 2016
PKG_SOURCE_VERSION:=556af3c2667f8802f243a46067d45b7430bf943b
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

#PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/babeldev
  SECTION:=net
  CATEGORY:=Network
  TITLE:=The layer 3 roaming daemon
  DEPENDS:=+libnl-tiny
endef

define Package/babeldev/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/babeldev $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,babeldev))

