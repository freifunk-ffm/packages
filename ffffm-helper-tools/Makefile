include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-helper-tools
PKG_VERSION:=2.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=ffffm
  CATEGORY:=Customization
  TITLE:=Small helper toolbox
  DEPENDS:=+gluon-core +busybox
endef

define Package/$(PKG_NAME)/description
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
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/help $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/nodeinfo $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/meshinfo $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
