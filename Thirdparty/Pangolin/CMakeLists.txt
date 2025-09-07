cmake_minimum_required(VERSION 3.12)
project("Pangolin")

# ==================================
#     C++ standard & flags
# ==================================
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
# set( CMAKE_CXX_FLAGS "-Wall -Wextra ${CMAKE_CXX_FLAGS}" ) # Uncomment to show compilation warnings

add_compile_options(-w) # Comment to show compilation warnings

# Build type default
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

# ========================================
#     SET VERSION
# ======================================== 

set(PANGOLIN_VERSION_MAJOR 0)
set(PANGOLIN_VERSION_MINOR 6)
set(PANGOLIN_VERSION ${PANGOLIN_VERSION_MAJOR}.${PANGOLIN_VERSION_MINOR})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules/")

# Platform configuration vars
include(SetPlatformVars)

SET(CPACK_GENERATOR "DEB")

SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Steven Lovegrove")
SET(CPACK_PACKAGE_VERSION_MAJOR ${PANGOLIN_VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${PANGOLIN_VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH "0")
include(CPack)

option( BUILD_EXAMPLES "Build Tools" ON )



string(TOLOWER ${PROJECT_NAME} LIBRARY_NAME)

# make an uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY
)

add_custom_target(pangolin_uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")

  
# Build tools
add_subdirectory("src")
set(Pangolin_DIR ${Pangolin_BINARY_DIR}/src)
add_subdirectory(tools)