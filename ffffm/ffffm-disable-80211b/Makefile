include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-disable-80211b
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/ffffm-disable-80211b
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Disable 802.11b
  DEPENDS:=+gluon-core
endef

define Package/gluon-legacy/description
	Disable 802.11b
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-disable-80211b/install
	$(CP) ./files/* $(1)/
endef

define Package/ffffm-disable-80211b/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,ffffm-disable-80211b))

