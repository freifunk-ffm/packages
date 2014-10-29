# Copyright (C) 2014 Christof Schulze <christof dot schulze at gmx.net>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-luci-switchconfig
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-luci-switchconfig
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Luci module for advanced wan port configuration
  DEPENDS:=+gluon-luci-admin
endef

define Package/gluon-luci-switchconfig/description
	Luci module for advanced wan port configuration
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-luci-switchconfig/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-luci-switchconfig))
