include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-autoupdater-use-site-conf-branch
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/ffffm-autoupdater-use-site-conf-branch
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

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-autoupdater-use-site-conf-branch
	$(CP) ./files/* $(1)/
endef

define Package/ffffm-autoupdater-use-site-conf-branch/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,ffffm-autoupdater-use-site-conf-branch))

