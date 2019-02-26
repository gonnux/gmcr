#include <fstream>
#include <boost/program_options.hpp>
#include <nlohmann/json.hpp>
#include <lua.hpp>
#include "lexer.hh"

using json = nlohmann::json;
void Gmcr::Lexer::pushArgs(const json& subArgs) {
    lua_newtable(m_luaState);
    size_t i = 1;
    for(json::const_iterator it = subArgs.begin(); it != subArgs.end(); ++it) {
        if(subArgs.is_object()) {
            lua_pushstring(m_luaState, it.key().c_str());
        } else {
            lua_pushinteger(m_luaState, i);
            ++i;
        }
        if(it->is_structured()) {
            Gmcr::Lexer::pushArgs(it.value());
        } else {
            if(it->is_null())
                lua_pushnil(m_luaState);
            else if(it->is_boolean())
                lua_pushboolean(m_luaState, it.value());
            else if(it->is_number())
                lua_pushnumber(m_luaState, it.value());
            else if(it->is_string())
                lua_pushstring(m_luaState, it.value().get<std::string>().c_str());
        }
        lua_settable(m_luaState, -3);
    }
}

Gmcr::Lexer::Lexer(std::string&& argsFilePath, std::istream* new_in, std::ostream* new_out) : yyFlexLexer(new_in, new_out), m_luaState{luaL_newstate()} {
    luaL_openlibs(m_luaState);
    if(argsFilePath == "")
        m_args = std::move("{}"_json);
    else {
        std::ifstream argsFile{argsFilePath};
        if(argsFile.fail()) {
            throw std::runtime_error(argsFilePath + ": " + strerror(errno));
        }
        argsFile >> m_args;
    }
    pushArgs(m_args);
    lua_setglobal(m_luaState, "args");
}

Gmcr::Lexer::~Lexer() {}
bool Gmcr::Lexer::eval(std::string&& content) {
    if(luaL_dostring(m_luaState, content.c_str())) {
        std::cout << lua_tostring(m_luaState, -1);
        lua_pop(m_luaState, 1);
        return false;
    }
    return true;
}
