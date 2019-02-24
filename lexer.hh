#include <iostream>
#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
namespace Gmcr {
    class Lexer : public yyFlexLexer {
    public:
        Lexer();
        virtual ~Lexer();
        std::string&& evaluate(std::string&&);
        int yylex();
    };
};
