include $(TOPDIR)/rules.mk

PKG_NAME:=mmfd
PKG_VERSION:=1

PKG_SOURCE_PROTO:=git
#PKG_SOURCE_URL=https://github.com/tcatm/mmfd.git
PKG_SOURCE_URL=https://github.com/freifunk-ffm/mmfd.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
# this is master from may 18th
# PKG_SOURCE_VERSION:=a743dde200f08c7d93c0b8a061aee5e27ef7c7ab
# this includes a hack hopefully fixing the broken ifup-startup 
PKG_SOURCE_VERSION:=8c24ecc9b34e9309ea765dd5e4e27a16e2b51f29
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

#PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/mmfd
  SECTION:=net
  CATEGORY:=Network
  TITLE:=mesh multicast forwarding daemon
  DEPENDS:=
endef
#  DEPENDS:=libnl-tiny

define Package/mmfd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/mmfd $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,mmfd))

