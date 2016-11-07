include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-dns-cache
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/ffffm-dns-cache
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Use Node as DNS cache, configure using site.conf
  DEPENDS:=+gluon-core +dnsmasq
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

define Package/ffffm-dns-cache/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffffm-dns-cache))

