#include <stdlib.h>

#define LUA_LIB
#define LUA_COMPAT_MODULE

#include "lua.h"
#include "lauxlib.h"

#include "ffffm.h"

static int get_nexthop(lua_State *L) {
	char *n = ffffm_get_nexthop();

	if (!n)
		return 0;

	lua_pushstring(L, n);
	free(n);
	return 1;
}

static inline void add_table_entry(lua_State *L, const char *name, double value, double invalid) {
	if (value != invalid) {
		lua_pushstring(L, name);
		lua_pushnumber(L, value);
		lua_settable(L,-3);
	}
}

static inline void add_channel(lua_State *L, const char *name, double value) {
	add_table_entry(L, name, value, FFFFM_INVALID_CHANNEL);
}

static inline void add_txpower(lua_State *L, const char *name, double value) {
	add_table_entry(L, name, value, FFFFM_INVALID_TXPOWER);
}

static inline void add_airtime(lua_State *L, const char *name, double value) {
	add_table_entry(L, name, value, FFFFM_INVALID_AIRTIME);
}

static int get_wifi_info(lua_State *L) {
	struct ffffm_wifi_info *i = ffffm_get_wifi_info();

	if (!i)
		return 0;

	lua_newtable(L);
	add_channel(L, "chan2", i->c24);
	add_channel(L, "chan5", i->c50);
	add_txpower(L, "txpower2", i->t24);
	add_txpower(L, "txpower5", i->t50);

	return 1;
}

static int get_airtime(lua_State *L) {
	struct ffffm_airtime *i = ffffm_get_airtime();
	if (!i)
		return 0;

	lua_newtable(L);
	add_airtime(L, "airtime2", i->a24);
	add_airtime(L, "airtime5", i->a50);

	return 1;
}

static const luaL_Reg ffffmlib[] = {
	{"get_nexthop", get_nexthop},
	{"get_wifi_info", get_wifi_info},
	{"get_airtime", get_airtime},
	{NULL, NULL},
};

LUALIB_API int luaopen_ffffm(lua_State *L) {
	luaL_register(L, "ffffm", ffffmlib);
	return 1;
}

LUALIB_API int luaopen_lua(lua_State *L) {
	return luaopen_ffffm(L);
}
