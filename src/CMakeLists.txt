find_library(lua_LIBRARIES NAMES liblua5.3.so liblua-5.3.so liblua-5.3.so.0 liblua.a REQUIRED)
find_path(lua_INCLUDE_DIRS NAMES lua.h lualib.h lauxlib.h PATHS /usr/include/lua5.3 REQUIRED)
find_package(FLEX REQUIRED)
flex_target(lexer gmcr.ll "${PROJECT_SOURCE_DIR}/src/lex.yy.cc")

add_executable(gmcr lex.yy.cc)

target_sources(
    gmcr
    PRIVATE
    lexer.cc
)

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
)

target_link_libraries(
    gmcr
    ${lua_LIBRARIES}
    boost_program_options
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
