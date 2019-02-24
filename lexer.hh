#include <iostream>
#include <fstream>
#include <stack>
#include <nlohmann/json.hpp>
#include <lua.h>
#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
using json = nlohmann::json;
namespace Gmcr {
    class Lexer : public yyFlexLexer {
    private:
        json m_args;
        lua_State* m_luaState;
        std::stack<std::ifstream*> m_fileStack;
        void pushArgs(const json&);
    public:
        Lexer(std::string&&);
        virtual ~Lexer();
        bool eval(std::string&&);
        int yylex();
    };
};
