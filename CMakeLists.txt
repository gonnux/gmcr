cmake_minimum_required(VERSION 3.5)
include(cmake/gonapps-cmake-helper.cmake)
project(gmcr CXX)

gonapps_setVersion("0.2.0" "0.2")
gonapps_setBuildType()

add_subdirectory(src)
