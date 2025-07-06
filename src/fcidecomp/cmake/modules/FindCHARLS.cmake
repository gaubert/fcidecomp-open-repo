# Print the CHARLS_ROOT if defined
if(NOT DEFINED CHARLS_ROOT)
    message(STATUS "CHARLS_ROOT not defined")
else()
    message(STATUS "Using CHARLS_ROOT: ${CHARLS_ROOT}")
endif()

# Save and override suffixes for platform-specific library types
set(_original_suffixes ${CMAKE_FIND_LIBRARY_SUFFIXES})

if(WIN32)
    # Look for static .lib files on Windows
    set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
else()
    # Look for static .a files on Linux/Unix
    set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
endif()

# Find the include directory
find_path(CHARLS_INCLUDE_DIRS
    NAMES charls/charls.h
    PATHS
        "${CHARLS_ROOT}/include"
        "${CHARLS_ROOT}"
    DOC "Path to the CharLS include directory"
)

# Find the static library
find_library(CHARLS_LIBRARIES
    NAMES charls
    PATHS
        "${CHARLS_ROOT}/lib"
        "${CHARLS_ROOT}"
    DOC "Path to the CharLS static library"
)

# Restore suffixes
set(CMAKE_FIND_LIBRARY_SUFFIXES ${_original_suffixes})

# Debug output
message(STATUS "CHARLS include dir: ${CHARLS_INCLUDE_DIRS}")
message(STATUS "CHARLS library: ${CHARLS_LIBRARIES}")

# Validate results
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CHARLS
    REQUIRED_VARS CHARLS_INCLUDE_DIRS CHARLS_LIBRARIES
    FOUND_VAR CHARLS_FOUND
)

# Mark internal variables as advanced
mark_as_advanced(CHARLS_INCLUDE_DIRS CHARLS_LIBRARIES)
