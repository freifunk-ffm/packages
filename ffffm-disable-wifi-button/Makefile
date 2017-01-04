include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-disable-wifi-button
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Network
  MAINTAINER:=Freifunk Frankfurt
  TITLE:=Disable WiFi Button
endef

define Package/gluon-legacy/description
	No action if the WiFi-Button is pushed.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

