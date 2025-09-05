cmake_minimum_required(VERSION 3.12)
project(ORB_SLAM3)

# ==================================
#     C++ standard & flags
# ==================================

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})

# Compilation flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=native")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=native")

# Hide warnings
add_compile_options(-w)

# ==================================
#     Dependencies
# ==================================

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

find_package(OpenCV 4.2.0 REQUIRED)
find_package(Eigen3 3.4.0 REQUIRED)
find_package(Pangolin REQUIRED)
find_package(DBoW2 REQUIRED)
find_package(g2o REQUIRED)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

# ==================================
#     Sources and Headers
# ==================================

file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc
  ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
)

# ==================================
#     Library
# ==================================

add_library(${PROJECT_NAME} SHARED
  ${SRC_FILES}
)

# Include headers
target_include_directories(${PROJECT_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${Eigen3_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:include>
)

# Link to OpenCV
target_link_libraries(${PROJECT_NAME}
	PUBLIC
		${OpenCV_LIBS}
    Eigen3::Eigen
		${Pangolin_LIBRARY}
		DBoW2::DBoW2
		g2o::g2o
		-lboost_serialization
		-lcrypto
)

# ==================================
#     Output path
# ==================================

set_target_properties(${PROJECT_NAME} PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
)

# ==================================
#     Installation
# ==================================

# install the lib, headers and export targets
install(TARGETS ${PROJECT_NAME}
    EXPORT ORB_SLAM3Targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

# Install headers
install(DIRECTORY include/ DESTINATION include)

# Export the targets (ORB_SLAMTargets.cmake)
install(EXPORT ORB_SLAM3Targets
    FILE ORB_SLAM3Targets.cmake
    NAMESPACE ORB_SLAM3::
    DESTINATION lib/cmake/ORB_SLAM3
)

# ==================================
#     Config file for find_package
# ==================================

# Generate ORB_SLAM3Config.cmake from template .in
include(CMakePackageConfigHelpers)

configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/ORB_SLAM3Config.cmake.in
    ${CMAKE_BINARY_DIR}/ORB_SLAM3Config.cmake
    @ONLY
)

install(FILES
    ${CMAKE_BINARY_DIR}/ORB_SLAM3Config.cmake
    DESTINATION lib/cmake/ORB_SLAM3
)