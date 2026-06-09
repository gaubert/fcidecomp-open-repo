cmake_minimum_required(VERSION 3.15)  # use 3.16+ later for FetchContent
cmake_policy(SET CMP0074 NEW)
cmake_policy(SET CMP0091 NEW)

project(fcidecomp_superbuild C CXX)

option(FCIDECOMP_ENABLE_COMPONENT_TESTS "Enable component/unit tests from subprojects" OFF)
option(FCIDECOMP_ENABLE_POSTINSTALL_TEST "Enable post-install smoke test via CTest" OFF)

include(CTest) # defines BUILD_TESTING option

# Disable subproject tests unless explicitly requested
set(BUILD_TESTING ${FCIDECOMP_ENABLE_COMPONENT_TESTS} CACHE BOOL "Build tests" FORCE)

# Ensure top-level testing is enabled if the post-install test is requested
if(FCIDECOMP_ENABLE_POSTINSTALL_TEST)
  enable_testing()
endif()

# Add subprojects
add_subdirectory(fcicomp-jpegls)
add_subdirectory(fcicomp-H5Zjpegls)

if(FCIDECOMP_ENABLE_POSTINSTALL_TEST)
  enable_testing()
  if(WIN32)
    set(POSTINSTALL_TEST_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/fcidecomp-test/postInstallationTest.bat)
  else()
    set(POSTINSTALL_TEST_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/fcidecomp-test/postInstallationTest.sh)
  endif()
  add_test(
    NAME post_installation_test
    COMMAND ${POSTINSTALL_TEST_COMMAND}
  )
  set_tests_properties(post_installation_test PROPERTIES
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    ENVIRONMENT "HDF5_PLUGIN_PATH=${CMAKE_BINARY_DIR}/fcicomp-H5Zjpegls"
  )
endif()
