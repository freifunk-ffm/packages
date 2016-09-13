include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-keep-radio-channel
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/ffffm-keep-radio-channel
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Keep Radio Channel after update script
  DEPENDS:=+gluon-core
endef

define Package/gluon-legacy/description
	Keep Radio Channel after update script
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-keep-radio-channel/install
	$(CP) ./files/* $(1)/
endef

define Package/ffffm-keep-radio-channel/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,ffffm-keep-radio-channel))

