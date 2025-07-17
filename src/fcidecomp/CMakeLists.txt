cmake_minimum_required(VERSION 3.10)  # use 3.16+ later for FetchContent
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

message(STATUS "CharLS include: ${CHARLS_INCLUDE_DIRS}")
message(STATUS "CharLS libs:    ${CHARLS_LIBRARIES}")

# Add your subprojects
add_subdirectory(fcicomp-jpegls)
add_subdirectory(fcicomp-H5Zjpegls)

