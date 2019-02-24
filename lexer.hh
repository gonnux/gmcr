#include <iostream>
#include <fstream>
#include <nlohmann/json.hpp>
#include <lua.h>
#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
namespace Gmcr {
    class Lexer : public yyFlexLexer {
    private:
        nlohmann::json args;
	lua_State* luaState;
    public:
        Lexer(std::string&&);
        virtual ~Lexer();
        bool eval(std::string&&);
        int yylex();
    };
};
