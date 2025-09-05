cmake_minimum_required(VERSION 3.12)
project(g2o LANGUAGES CXX)

# ==================================
#     C++ standard & flags
# ==================================
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

# OpenCV
find_package(OpenCV 4 QUIET)
if(NOT OpenCV_FOUND)
  find_package(OpenCV 3.0 QUIET)
  if(NOT OpenCV_FOUND)
    message(FATAL_ERROR "OpenCV >= 3.0 not found")
  endif()
endif()

# ==================================
#     Sources and Headers
# ==================================
file(GLOB_RECURSE SRCS_DBOW2  "${CMAKE_CURRENT_SOURCE_DIR}/src/DBoW2/*.cpp")
file(GLOB_RECURSE SRCS_DUTILS "${CMAKE_CURRENT_SOURCE_DIR}/src/DUtils/*.cpp")

# ==================================
#     Library
# ==================================
add_library(DBoW2 SHARED
  ${SRCS_DBOW2}
  ${SRCS_DUTILS}
)

# Include headers
target_include_directories(DBoW2
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${OpenCV_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:include>
)

# Link to OpenCV
target_link_libraries(DBoW2 PUBLIC ${OpenCV_LIBS})

# ==================================
#     Output path
# ==================================

set_target_properties(DBoW2 PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
)

# ==================================
#     Installation
# ==================================

# Install headers
install(DIRECTORY include/ DESTINATION include)

# Install targets
install(TARGETS DBoW2
  EXPORT DBoW2Config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)

# Export targets
install(EXPORT DBoW2Config
  FILE DBoW2Config.cmake
  NAMESPACE DBoW2::
  DESTINATION lib/cmake/DBoW2
)


