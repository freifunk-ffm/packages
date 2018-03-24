include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-autoupdater-use-site-conf-branch
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Use the update branch from site.conf instead of GLUON_BRANCH
  DEPENDS:=+gluon-core
endef

define Package/gluon-legacy/description
	Use the update branch from site.conf instead of GLUON_BRANCH
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

