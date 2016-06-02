# guessed...
cmake_minimum_required(VERSION 2.6)
PROJECT(ffffmlib C)

INCLUDE(CMakeDependentOption)

option(BUILD_SHARED_LIBS "Use shared libraries" ON)
option(RESPONDD "Enable respondd support" ON)
option(LUA "Enable lua support" ON)
option(INSTALL_TESTS "Also install test binaries" OFF)
CMAKE_DEPENDENT_OPTION(ALFRED "Enable alfred support" ON "LUA" ON)

set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(LUA_PACKAGE lua5.1 lua)
set(CMAKE_C_FLAGS "-O3 -Wall --std=c99 -g3 -Wpedantic")

INCLUDE(FindPkgConfig)
pkg_search_module(UNL REQUIRED libnl-tiny)

if(LUA)
	pkg_search_module(LUA REQUIRED ${LUA_PACKAGE})

	if(NOT LUAPATH)
		if(DEFINED pkg_get_variable)
			pkg_get_variable(LUAPATH ${LUA_PACKAGE} INSTALL_CMOD)
		else()
			execute_process(
				COMMAND  lua -e "for k in string.gmatch(package.cpath .. \";\", \"([^;]+)/..so;\") do if k:sub(1,1) == \"/\" then print(k) break end end"
				OUTPUT_VARIABLE LUAPATH
				RESULT_VARIABLE LUA_CHECK_RES
				OUTPUT_STRIP_TRAILING_WHITESPACE
				)
		endif()
	endif()

endif()

if(RESPONDD)
	pkg_search_module(JSON REQUIRED json-c)
endif()

add_library(ffffm nexthop.c wifi_info.c airtime.c)
target_link_libraries(ffffm uci ${UNL_LIBRARIES})
target_include_directories(ffffm PUBLIC ${UNL_INCLUDE_DIRS})
install(TARGETS ffffm
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib/static)

if(RESPONDD)
	add_library(respondd-nexthop SHARED respondd-nexthop.c) # FIXME make this a module
	target_link_libraries(respondd-nexthop ffffm ${JSON_LIBRARIES})
	target_include_directories(respondd-nexthop PUBLIC ${JSON_INCLUDE_DIRS})
#	install(FILES $<TARGET_FILE:respondd-nexthop>
	install(FILES librespondd-nexthop.so
		RENAME nexthop.so
		DESTINATION lib/gluon/respondd/)

	add_library(respondd-wireless SHARED respondd-wireless.c) # FIXME make this a module
	target_link_libraries(respondd-wireless ffffm ${JSON_LIBRARIES})
	target_include_directories(respondd-wireless PUBLIC ${JSON_INCLUDE_DIRS})
#	install(FILES $<TARGET_FILE:respondd-wireless>
	install(FILES librespondd-wireless.so
		RENAME wireless.so
		DESTINATION lib/gluon/respondd/)
endif()

if(LUA)
	add_library(ffffm-lua SHARED ffffm-lua.c) # FIXME make this a module
	target_include_directories(ffffm-lua PUBLIC ${LUA_INCLUDE_DIRS})
	target_link_libraries(ffffm-lua ffffm ${LUA_LIBRARIES})
#	install(FILES $<TARGET_FILE:ffffm-lua>
	install(FILES libffffm-lua.so
		RENAME ffffm.so
		DESTINATION ${LUAPATH})
endif()

if(ALFRED)
	install(FILES gluon-announce-nodeinfo-wireless.lua
		RENAME wireless
		DESTINATION lib/gluon/announce/nodeinfo.d)
	install(FILES gluon-announce-statistics-wireless.lua
		RENAME wireless
		DESTINATION lib/gluon/announce/statistics.d)
	install(FILES gluon-announce-statistics-nexthop.lua
		RENAME nexthop
		DESTINATION lib/gluon/announce/statistics.d)
endif()

enable_testing()

add_executable(ffffm-test ffffm-test.c)
target_link_libraries(ffffm-test ffffm)
add_test(NAME ffffm-test COMMAND ffffm-test)
if(INSTALL_TESTS)
	install(TARGETS ffffm-test
		RUNTIME DESTINATION bin)
endif()

if(RESPONDD)
	add_executable(ffffm-respondd-test ffffm-respondd-test.c)
	target_link_libraries(ffffm-respondd-test dl ${JSON_LIBRARIES})
	target_include_directories(ffffm-respondd-test PUBLIC ${JSON_INCLUDE_DIRS})
	if(INSTALL_TESTS)
		install(TARGETS ffffm-respondd-test
			RUNTIME DESTINATION bin)
	endif()
endif()

if(LUA)
	add_test(NAME ffffm-lua-test COMMAND ffffm-lua-test)
	if(INSTALL_TESTS)
		install(PROGRAMS ffffm-lua-test
			DESTINATION bin)
	endif()
endif()
