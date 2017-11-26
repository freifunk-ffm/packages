include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-ath9k-broken-wifi-workaround
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
	SECTION:=ffffm
	CATEGORY:=Customization
	TITLE:=ath9k broken wifi workaround
	DEPENDS:=+gluon-core +micrond
endef

define Package/gluon-legacy/description
	Restart wifi, if there were client or mesh connection problems after the last restart or reboot
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/files
	cp -r $(PKG_BUILD_DIR)/luadest/* $(PKG_BUILD_DIR)/files
	sed -i '/^# /d' $(PKG_BUILD_DIR)/files/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh
	sed -i '/^##/d' $(PKG_BUILD_DIR)/files/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh
	sed -i /^$$$$/d $(PKG_BUILD_DIR)/files/lib/gluon/ath9k-broken-wifi-workaround/ath9k-broken-wifi-workaround.sh
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/$(PKG_NAME)/install
	$(CP) $(PKG_BUILD_DIR)/files/* $(1)/

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
