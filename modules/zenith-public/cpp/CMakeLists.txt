# Zenith C++ modules.
#
# With this file present, cmake/Modules.cmake includes it instead of globbing the folder, so it adds
# the sources to xi_map itself, the same way the glob would.
#
# It also builds the modules that add Lua bindings into xi_test, so scripts/tests/zenith/*.lua can call
# them. This file is included from src/map, before src/test defines xi_test, so that step is deferred
# to the end of the top-level directory.

file(GLOB_RECURSE ZXI_CPP_MODULE_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/*.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/*.h"
)

target_sources(xi_map PRIVATE ${ZXI_CPP_MODULE_SOURCES})
target_include_directories(xi_map PRIVATE "${CMAKE_CURRENT_LIST_DIR}")

function(zxi_add_cpp_modules_to_xi_test)
    if(TARGET xi_test)
        target_sources(xi_test PRIVATE
            ${CMAKE_SOURCE_DIR}/modules/zenith-public/cpp/spawn_slot_lua.cpp
        )
    endif()
endfunction()

cmake_language(DEFER DIRECTORY ${CMAKE_SOURCE_DIR} CALL zxi_add_cpp_modules_to_xi_test)
