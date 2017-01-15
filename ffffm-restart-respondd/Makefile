include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-restart-respondd
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=gluon
	CATEGORY:=Gluon
	TITLE:=respondd restart
	DEPENDS:=+gluon-core +micrond
endef

define Package/gluon-legacy/description
	If the respondd process is terminated due to voodoo, restart it again.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/files
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
