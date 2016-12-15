include $(TOPDIR)/rules.mk

PKG_NAME:=l3roamd
PKG_VERSION:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/tcatm/l3roamd.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
# this is master from april 14th
#PKG_SOURCE_VERSION:=14e87caa275be2432ae0fcc7242742946851d327

# this is master from may 6th
PKG_SOURCE_VERSION:=9d474a9329e307a5e71fd55d53491d93d34dda13

# this is master from may 10th
# PKG_SOURCE_VERSION:=beed3370c735f81f27a4d7763d87fd7a213a428a
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

#PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
CMAKE_OPTIONS +=  I-DCMAKE_BUILD_TYPE:STRING=MINSIZEREL

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/l3roamd
  SECTION:=net
  CATEGORY:=Network
  TITLE:=The layer 3 roaming daemon
  DEPENDS:=+libnl-tiny +kmod-cfg80211
endef

define Package/l3roamd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/l3roamd $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,l3roamd))

