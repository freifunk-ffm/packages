# guessed...
cmake_minimum_required(VERSION 2.6)
PROJECT(ffffmlib C)

INCLUDE(CMakeDependentOption)

option(BUILD_SHARED_LIBS "Use shared libraries" ON)
option(RESPONDD "Enable respondd support" ON)
option(INSTALL_TESTS "Also install test binaries" OFF)

set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(CMAKE_C_FLAGS "-O3 -Wall --std=c99 -g3 -Wpedantic")

INCLUDE(FindPkgConfig)
pkg_search_module(UNL REQUIRED libnl-tiny)

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
