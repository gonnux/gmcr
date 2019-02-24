#include <iostream>
#include "lexer.hh"
Gmcr::Lexer::Lexer() {}
Gmcr::Lexer::~Lexer() {}
std::string&& Gmcr::Lexer::evaluate(std::string&& content) {
    return std::move(content);
}
/*
int GmcrLexer::yylex() {
    return 0;
}
*/
