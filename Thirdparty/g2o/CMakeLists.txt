cmake_minimum_required(VERSION 3.12)
project(g2o LANGUAGES CXX)

# ==================================
#     C++ standard & flags
# ==================================

# CXX version
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=native") # Comment to show compilation warnings
# set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall -03 -march=native") # Uncomment to show compilation warnings

# Build type default
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

add_compile_options(-w) # Comment to show compilation warnings

# ==================================
#     Dependencies
# ==================================

# Eigen
find_package(Eigen3 3.4.0 REQUIRED)
if (NOT EIGEN3_FOUND)
    message(FATAl_ERROR "Eigen3 >= 3.4.0 not found")
else()
    message("Eigen3 found! Version: ${EIGEN3_VERSION}")
endif()

# OpenMP (optional, experimental)
find_package(OpenMP)
option(G2O_USE_OPENMP "Build g2o with OpenMP support (EXPERIMENTAL)" OFF)
if(OpenMP_FOUND AND G2O_USE_OPENMP)
  message(STATUS "Compiling with OpenMP support")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS} -DEIGEN_DONT_PARALLELIZE")
endif()

# ==================================
#     Config.h generation
# ==================================
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/g2o/config/config.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/g2o/config/config.h
)

# ==================================
#     Sources
# ==================================

# Source files
file(GLOB_RECURSE SRCS_CORE   "${CMAKE_CURRENT_SOURCE_DIR}/src/core/*.cpp")
file(GLOB_RECURSE SRCS_TYPES  "${CMAKE_CURRENT_SOURCE_DIR}/src/types/*.cpp")
file(GLOB_RECURSE SRCS_STUFF  "${CMAKE_CURRENT_SOURCE_DIR}/src/stuff/*.cpp")

# All sources
set(SRCS_G2O
  ${SRCS_CORE}
  ${SRCS_TYPES}
  ${SRCS_STUFF}
)

# ==================================
#     Library
# ==================================
add_library(g2o SHARED 
	${SRCS_G2O}
)

# Include headers
target_include_directories(g2o
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${EIGEN3_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:include>
)

# ==================================
#     Output path
# ==================================
set_target_properties(g2o PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
)

# ==================================
#     Installation
# ==================================

# Install headers
install(DIRECTORY include/ DESTINATION include)

# Install targets
install(TARGETS g2o
  EXPORT g2oConfig
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)

# Export targets
install(EXPORT g2oConfig
  FILE g2oConfig.cmake
  NAMESPACE g2o::
  DESTINATION lib/cmake/g2o
)
