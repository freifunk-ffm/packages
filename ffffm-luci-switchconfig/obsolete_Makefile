# Copyright (C) 2014 Christof Schulze <christof dot schulze at gmx.net>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-luci-switchconfig
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffffm-luci-switchconfig
  SECTION:=ffffm
  CATEGORY:=Gluon
  TITLE:=Luci module for advanced wan port configuration
  DEPENDS:=+gluon-luci-admin
endef

define Package/ffffm-luci-switchconfig/description
	Luci module for advanced wan port configuration
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-luci-switchconfig/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-luci-switchconfig))
