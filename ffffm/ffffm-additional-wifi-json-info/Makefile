include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-additional-wifi-json-info
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

CMAKE_OPTIONS = -DLUAPATH=/usr/lib/lua -DINSTALL_TESTS=ON $(if $(DEBUG),-DUCI_DEBUG=ON)

define Package/ffffm-additional-wifi-json-info
	TITLE:=$(PKG_NAME)
	CATEGORY:=Network
	MAINTAINER:=t-8ch
	DEPENDS:=+lua +libnl-tiny +respondd +libuci
endef

define Package/ffffm-additional-wifi-json-info/description
	Some additional wifi device information for the ffffm JSON file.
        This package should work with Gluon v2015.1.x (alfred) and Gluon v2016.1.x (respondd)  
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/ffffm-additional-wifi-json-info/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_DIR) $(1)/usr/lib/gluon/respondd
	$(INSTALL_DIR) $(1)/lib/gluon/announce/statistics.d/
	$(INSTALL_DIR) $(1)/lib/gluon/announce/nodeinfo.d/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libffffm.so $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/ffffm-test $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/ffffm-respondd-test $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/lua/ffffm.so $(1)/usr/lib/lua/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/gluon/respondd/wireless.so $(1)/usr/lib/gluon/respondd/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/gluon/respondd/nexthop.so $(1)/usr/lib/gluon/respondd/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/gluon/announce/nodeinfo.d/wireless $(1)/lib/gluon/announce/nodeinfo.d/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/gluon/announce/statistics.d/wireless $(1)/lib/gluon/announce/statistics.d/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/gluon/announce/statistics.d/nexthop $(1)/lib/gluon/announce/statistics.d/
endef
 
$(eval $(call BuildPackage,ffffm-additional-wifi-json-info))
