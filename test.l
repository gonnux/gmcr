%{
#include "lexer.hh"
#include <stdio.h>
%}
%option nodefault
%option noyywrap
%option c++
%x MACRO

%%
\{\{        { BEGIN(MACRO); }
<MACRO>\}\} { BEGIN(INITIAL); }
<MACRO>\\\}\} { printf("[%s]\n", yytext); }
<MACRO>\n    { printf("[%s]\n", yytext); }
<MACRO>.    { printf("[%s]\n", yytext); }
. { ECHO; }
\n { ECHO; }
%%
int main() {
    FlexLexer* lexer = new MyLexer;
    while(lexer->yylex() != 0) ;
        return 0;
}
