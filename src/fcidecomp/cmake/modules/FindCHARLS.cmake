# =============================================================
#
# Copyright 2015-2023, European Organisation for the Exploitation of Meteorological Satellites (EUMETSAT)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# =============================================================

# AUTHORS:
# - THALES Services
# - B-Open Solutions srl
# - EUMETSAT Guillaume Aubert

# - Find CharLS, an optimized JPEG-LS compression library
#
# To provide the module with a hint about where to find your CharLS
# installation, you can set the environment variable CHARLS_ROOT.  The
# Find module will then look in this path when searching for CharLS
# paths, and libraries.
#
# This module will define the following variables:
# CHARLS_FOUND       - Indicates whether the library has been found at all
# CHARLS_LIBRARY     - Name of the library to link
# CHARLS_INCLUDE_DIR - Path to the header files to include
#
# Try to locate the CharLS library and headers using the CHARLS_ROOT hint

if(NOT DEFINED CHARLS_ROOT)
    message(STATUS "CHARLS_ROOT not defined")
else()
    message(STATUS "Using CHARLS_ROOT: ${CHARLS_ROOT}")
endif()

# Prefer static libraries
set(_original_suffixes ${CMAKE_FIND_LIBRARY_SUFFIXES})
set(CMAKE_FIND_LIBRARY_SUFFIXES .a)

# Find include directory
find_path(CHARLS_INCLUDE_DIRS
  NAMES charls/charls.h
  PATHS
    ${CHARLS_ROOT}/include
    ${CHARLS_ROOT}
  DOC "Path to the CharLS include directory"
)

# Find static library
find_library(CHARLS_LIBRARIES
  NAMES charls CharLS
  PATHS
    ${CHARLS_ROOT}/lib
    ${CHARLS_ROOT}
  DOC "Path to the CharLS static library"
)

# Restore original suffixes (for downstream compatibility)
set(CMAKE_FIND_LIBRARY_SUFFIXES ${_original_suffixes})

# Validate results
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CharLS
  REQUIRED_VARS CHARLS_INCLUDE_DIRS CHARLS_LIBRARIES
  FOUND_VAR CHARLS_FOUND
)

# Mark internal cache variables as advanced
mark_as_advanced(CHARLS_INCLUDE_DIRS CHARLS_LIBRARIES)

