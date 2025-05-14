include(FetchContent)

FetchContent_Declare(
  charls
  URL https://github.com/team-charls/charls/archive/refs/tags/2.4.1.tar.gz
)

FetchContent_MakeAvailable(charls)

# Manually set up usage info (simulate FindCharLS)
set(CHARLS_INCLUDE_DIRS ${charls_SOURCE_DIR}/src)
set(CHARLS_LIBRARIES charls)

