include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-ath9k-broken-wifi-workaround
PKG_VERSION:=1
PKG_RELEASE:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffffm-ath9k-broken-wifi-workaround
  SECTION:=ffffm
  CATEGORY:=Customization
  TITLE:=ath9k broken wifi workaround
  DEPENDS:=+gluon-core +micrond
endef

define Package/gluon-legacy/description
	Restart wifi, if there were client or mesh connection problems after the last restart or reboot
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-ath9k-broken-wifi-workaround/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-ath9k-broken-wifi-workaround))
