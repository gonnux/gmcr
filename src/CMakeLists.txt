find_library(lua_LIBRARIES NAMES liblua5.3.so liblua-5.3.so liblua-5.3.so.0 liblua.a PATHS /usr/lib/lua5.3 REQUIRED)
find_path(lua_INCLUDE_DIRS NAMES lua.hpp PATHS /usr/include/lua5.3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS program_options)
find_package(FLEX REQUIRED)
flex_target(lexer gmcr.ll "${PROJECT_SOURCE_DIR}/src/lex.yy.cc")

add_executable(gmcr lexer.cc lex.yy.cc)

target_compile_options(gmcr PRIVATE -Wall)

set_target_properties(
    gmcr
    PROPERTIES
    CXX_STANDARD 11
    VERSION ${version}
    SOVERSION ${soversion}
    PUBLIC_HEADER ""
)

target_include_directories(
    gmcr
    PRIVATE
    ${PROJECT_BINARY_DIR}
    ${lua_INCLUDE_DIRS}
    ${Boost_INCLUDE_DIRS}
    ${FLEX_INCLUDE_DIRS}
)

target_link_libraries(
    gmcr
    ${lua_LIBRARIES}
    ${Boost_PROGRAM_OPTIONS_LIBRARY}
)

configure_file(
    "${PROJECT_SOURCE_DIR}/src/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
    @ONLY
)

install(
    TARGETS gmcr
    RUNTIME DESTINATION bin
)
