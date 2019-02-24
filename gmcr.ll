%{
//#define YY_DECL int Gmcr::Lexer::yylex()
#include "lexer.hh"
#include <iostream>
%}
%option nodefault
%option noyywrap
%option c++
%option yyclass="Gmcr::Lexer"
%s GMCR_STATE_INCLUDE
%s GMCR_STATE_MACRO

%%

\{\{include[[:space:]] BEGIN(GMCR_STATE_INCLUDE);
<GMCR_STATE_INCLUDE>{
  [^\\}]* yymore();
  (.|\n) yymore();
  \\\} yymore();
  \}\} { BEGIN(INITIAL); std::cout << "INCLUDE END[" << YYText() << "]" << std::endl; }
}

<INITIAL>\{\{[[:space:]] BEGIN(GMCR_STATE_MACRO);
<GMCR_STATE_MACRO>{
  [^\\}]* yymore();
  (.|\n) { std::cout << "YES" << std::endl; yymore(); }
  \\\} yymore();
  \}\} {
    std::string content = YYText();
    content = std::move(content.substr(0, content.size() - 2));
    std::cout << this->evaluate(std::move(content));
    BEGIN(INITIAL);
  }
}

.|\n ECHO;

%%
int main(int argc, char** argv) {
    FlexLexer* lexer = new Gmcr::Lexer;
    while(lexer->yylex() != 0) ;
        return 0;

}
