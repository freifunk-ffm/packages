include $(TOPDIR)/rules.mk

PKG_NAME:=dnrd
PKG_VERSION:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=git@github.com:benjaminpetrin/dnrd.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
# this is master from sep 19th
PKG_SOURCE_VERSION:=092e4a7ca7f7b6d61ffcdb7fe3e4315ae326203c
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

#PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/dnrd
  SECTION:=net
  CATEGORY:=Network
  TITLE:=small dns cache
  DEPENDS:=
endef

define Package/dnrd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/dnrd $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,dnrd))

