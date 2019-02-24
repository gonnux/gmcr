#include <fstream>
#include <boost/program_options.hpp>
#include <nlohmann/json.hpp>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "lexer.hh"

Gmcr::Lexer::Lexer(std::string&& argsFilePath) : luaState{luaL_newstate()} {
    luaL_openlibs(luaState);
    std::cerr << "--args-file: " << argsFilePath << std::endl;
    std::ifstream argsFile{argsFilePath};
    argsFile >> args;
}
Gmcr::Lexer::~Lexer() {}
bool Gmcr::Lexer::eval(std::string&& content) {
    if(luaL_dostring(luaState, content.c_str())) {
        std::cout << lua_tostring(luaState, -1) << std::endl;
	lua_pop(luaState, 1);
	return false;
    }
    return true;
}
