include $(TOPDIR)/rules.mk

PKG_NAME:=babeldev
PKG_VERSION:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/christf/babeld.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=775bc48adab3bde1ce7a60b1f1f560f5bc269c34
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

#
# Copyright (C) 2007-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(INCLUDE_DIR)/package.mk

define Package/babeldev
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Routing and Redirection
	PROVIDES:=babeld
	TITLE:=A loop-free distance-vector routing protocol
	URL:=http://www.pps.univ-paris-diderot.fr/~jch/software/babel/
	MAINTAINER:=Gabriel Kerneis <gabriel@kerneis.info>
	DEPENDS:=@IPV6
endef

define Package/babeldev/description
 Babel is a loop-avoiding distance-vector routing protocol roughly based
 on DSDV and AODV, but with provisions for link cost estimation and
 redistribution of routes from other routing protocols.
 While it is optimised for wireless mesh networks, Babel will also work
 efficiently on wired networks. It will generate between 1.2 and 2.4 times
 the amount of routing traffic that RIPng would generate, while
 never counting to infinity.
endef

MAKE_FLAGS+= \
        CFLAGS="$(TARGET_CFLAGS)" \
        LDLIBS="" \

define Package/babeldev/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/babeld $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,babeldev))

