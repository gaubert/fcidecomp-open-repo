cmake_minimum_required(VERSION 3.15)  # use 3.16+ later for FetchContent
cmake_policy(SET CMP0074 NEW)
cmake_policy(SET CMP0091 NEW)

project(fcidecomp_superbuild C CXX)

# Add subprojects
add_subdirectory(fcicomp-jpegls)
add_subdirectory(fcicomp-H5Zjpegls)

