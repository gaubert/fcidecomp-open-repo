cmake_minimum_required(VERSION 3.10)  # use 3.16+ later for FetchContent
project(fcidecomp_superbuild C CXX)

# Add custom module path for FindCharLS
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

# Option 1: Manual CHARLS_ROOT
if(DEFINED CHARLS_ROOT)
  message(STATUS "Using CHARLS_ROOT: ${CHARLS_ROOT}")
  find_package(CHARLS REQUIRED)
else()
  message(FATAL_ERROR "CHARLS_ROOT is not set and automatic fetching is disabled.
Please specify -DCHARLS_ROOT=/path/to/charls install prefix.")

  # Uncomment this block when you upgrade to CMake ≥ 3.11
  # include(FetchContent)
  # include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/FetchCharLS.cmake)
endif()

message(STATUS "CharLS include: ${CHARLS_INCLUDE_DIRS}")
message(STATUS "CharLS libs:    ${CHARLS_LIBRARIES}")

# Add your subprojects
add_subdirectory(fcicomp-jpegls)
add_subdirectory(fcicomp-H5Zjpegls)

