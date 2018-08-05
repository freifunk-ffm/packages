cmake_minimum_required(VERSION 2.6)
project(ffffmlib C)

option(RESPONDD "Enable respondd support" ON)
option(INSTALL_TESTS "Also install test binaries" OFF)

include(FindPkgConfig)
pkg_search_module(JSON REQUIRED json-c)

if(RESPONDD)
	add_library(respondd-alert SHARED
		nodealert.c
		respondd-alert.c
	)
	set_target_properties(respondd-alert PROPERTIES
		PREFIX ""
	)
	target_include_directories(respondd-alert
		PRIVATE
			${JSON_INCLUDE_DIRS}
	)
	target_link_libraries(respondd-alert
		uci
		${JSON_LIBRARIES}
	)
	install(TARGETS respondd-alert
		LIBRARY DESTINATION lib
	)
endif(RESPONDD)

enable_testing()

# alert-test: include and link json-c
add_executable(alert-test
	nodealert.c
	alert-test.c
)
target_link_libraries(alert-test
	uci
	${JSON_LIBRARIES}
)
target_include_directories(alert-test
	PRIVATE
		${JSON_INCLUDE_DIRS}
)

add_test(NAME alert-test COMMAND alert-test)

if(INSTALL_TESTS)
	install(TARGETS alert-test
		RUNTIME DESTINATION bin)
endif(INSTALL_TESTS)
