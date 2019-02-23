%{
//#define YY_DECL int MyLexer::yylex()
#include "lexer.hh"
#include <iostream>
%}
%option nodefault
%option noyywrap
%option c++
%option yyclass="MyLexer"
%s GMCR_STATE_INCLUDE
%s GMCR_STATE_MACRO

%%

\{\{include[[:space:]] BEGIN(GMCR_STATE_INCLUDE);
<GMCR_STATE_INCLUDE>{
  [^\\}]* yymore();
  (.|\n) { yymore(); }
  \\\} { yymore(); }
  \}\} { BEGIN(INITIAL); std::cout << "INCLUDE END[" << YYText() << "]" << std::endl; }
}

\{\{[[:space:]] BEGIN(GMCR_STATE_MACRO);
<GMCR_STATE_MACRO>{
  [^\\}]* yymore();
  (.|\n) { yymore(); }
  \\\} { yymore(); }
  \}\} { BEGIN(INITIAL); std::cout << "MACRO END[" << YYText() << "]" << std::endl; }
}

%%
int main() {
    FlexLexer* lexer = new MyLexer;
    while(lexer->yylex() != 0) ;
        return 0;

}
