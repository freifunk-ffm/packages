include $(TOPDIR)/rules.mk

PKG_NAME:=ffffm-banner_legacy
PKG_VERSION:=1.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=ffffm
  CATEGORY:=Customization
  TITLE:=Banner file replacement and a small help toolbox
  DEPENDS:=+gluon-core +busybox
endef

define Package/$(PKG_NAME)/description
	Banner file replacement and a small help toolbox
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/preinst
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
if [ -h "./banner" ] ; then
	/bin/rm "./banner"
elif [ -f "./banner" ] ; then
	/bin/mv "./banner" "./banner.openwrt"
fi
/bin/ln -s "./banner.openwrt" "./banner"
exit 0
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
[ -h "./banner" ] && /bin/rm -f "./banner"
/bin/ln -s "./banner.ffmod" "./banner"
exit $$?
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
if [ -h "./banner" ] ; then
	[[ "$$(readlink -n ./banner)" == "./banner.ffmod" ]] && \
	/bin/rm -f "./banner" && \
	[ -f "./banner.openwrt" ] && \
	/bin/ln -s "./banner.openwrt" "./banner"
fi
exit 0
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DATA) ./files/etc/banner.ffmod $(1)/etc/
	$(INSTALL_BIN) ./files/usr/bin/help $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/nodeinfo $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/meshinfo $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
