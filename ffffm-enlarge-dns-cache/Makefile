include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-enlarge-dns-cache
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/ffffm-enlarge-dns-cache
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Enlarge the DNS cache size
  DEPENDS:=+gluon-core
endef

define Package/gluon-legacy/description
	Enlarge the DNS cache size
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffffm-enlarge-dns-cache/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-enlarge-dns-cache))

