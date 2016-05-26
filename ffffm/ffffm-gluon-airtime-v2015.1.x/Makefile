include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-gluon-airtime-v2015.1.x
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffffm-gluon-airtime-v2015.1.x
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Airtime and Wifi Channel reporter
  DEPENDS:=+gluon-core
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-gluon-airtime-v2015.1.x/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-gluon-airtime-v2015.1.x))

