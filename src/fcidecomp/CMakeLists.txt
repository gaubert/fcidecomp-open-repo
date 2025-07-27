cmake_minimum_required(VERSION 3.16)  # use 3.16+ later for FetchContent
cmake_policy(SET CMP0074 NEW)

project(fcidecomp_superbuild C CXX)


#cmake_policy(SET CMP0091 NEW)
# CMP0091: MSVC.  Use /MT or /MD on MSVC depending on your preference
#if(MSVC)
#	  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")  # Static /MT, /MTd
#endif()

# Add custom module path for FindCharLS
#set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

  # Uncomment this block when you upgrade to CMake ≥ 3.11
  # include(FetchContent)
  # include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/FetchCharLS.cmake)
  #endif()


# --- CharLS Integration with URL ---
#include(FetchContent)

#FetchContent_Declare(
#  charls
#  URL "https://github.com/team-charls/charls/archive/refs/tags/2.4.2.tar.gz"
#  URL_HASH SHA256=d1c2c35664976f1e43fec7764d72755e6a50a80f38eca70fcc7553cad4fe19d9
#  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
#)
#  FIND_PACKAGE_ARGS NAMES CharLS

#FetchContent_MakeAvailable(charls)

# Set a variable to pass CharLS source directory to subdirectories
# Option 1: Using set (most common and usually sufficient)
#set(CHARLS_SOURCE_LOCATION_FOR_SUBPROJECTS "${charls_SOURCE_DIR}" CACHE INTERNAL "Path to CharLS source for subprojects")
#set(CHARLS_BINARY_LOCATION_FOR_SUBPROJECTS "${charls_BINARY_DIR}" CACHE INTERNAL "Path to CharLS source for subprojects")
# The CACHE INTERNAL part makes it a cached variable, but for this use case,
# a simple 'set' before add_subdirectory also works.
# set(CHARLS_SOURCE_LOCATION_FOR_SUBPROJECTS "${charls_SOURCE_DIR}") # This also works.

message(STATUS "charls_SOURCE_DIR: ${charls_SOURCE_DIR}")
message(STATUS "charls_BINARY_DIR: ${charls_BINARY_DIR}")
message(STATUS "CHARLS_SOURCE_LOCATION_FOR_SUBPROJECTS: ${CHARLS_SOURCE_LOCATION_FOR_SUBPROJECTS}")
message(STATUS "CHARLS_BINARY_LOCATION_FOR_SUBPROJECTS: ${CHARLS_BINARY_LOCATION_FOR_SUBPROJECTS}")

message(STATUS "CharLS include: ${CHARLS_INCLUDE_DIRS}")
message(STATUS "CharLS libs:    ${CHARLS_LIBRARIES}")

# Add your subprojects
add_subdirectory(fcicomp-jpegls)
add_subdirectory(fcicomp-H5Zjpegls)

