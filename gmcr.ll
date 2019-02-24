%{
//#define YY_DECL int Gmcr::Lexer::yylex()
#include "lexer.hh"
#include <iostream>
#include <fstream>
#include <memory>
#include <boost/program_options.hpp>
#define GMCR_END " }}#"
%}
%option nodefault
%option noyywrap
%option c++
%option yyclass="Gmcr::Lexer"
%s GMCR_STATE_INCLUDE
%s GMCR_STATE_MACRO
GMCR_BEGIN #\{\{
GMCR_CONTENT .|\n
GMCR_ESCCHAR [^\\[[:space:]]\}#]
GMCR_ESCAPE .?\\[[:space:]]\}\}#
GMCR_END [[:space:]]\}\}#
%%


{GMCR_BEGIN}i[[:space:]] BEGIN(GMCR_STATE_INCLUDE);
<GMCR_STATE_INCLUDE>{
  {GMCR_CONTENT} yymore();
  GMC_ESCAPE_CHAR* yymore();
  {GMCR_ESCAPE} std::cout << GMCR_END;
  {GMCR_END} {
    std::string path = YYText();
    path = std::move(path.substr(0, path.size() - (sizeof(GMCR_END) - 1)));
    auto file = new std::ifstream{path};
    if(!file->is_open()) {
        std::cerr << "Cannot include " << path << std::endl;
        yyterminate();
    }
    yypush_buffer_state(yy_create_buffer(*file, YY_BUF_SIZE));
    m_fileStack.push(file);
    BEGIN(INITIAL);
  }
}

<INITIAL>{GMCR_BEGIN}c[[:space:]] BEGIN(GMCR_STATE_MACRO);
<GMCR_STATE_MACRO>{
  {GMCR_CONTENT} yymore();
  GMCR_ESCAPE_CHAR* { yymore(); }
  {GMCR_ESCAPE} yymore();
  {GMCR_END} {
    std::string content = YYText();
    content = std::move(content.substr(0, content.size() - (sizeof(GMCR_END) - 1)));
    if(this->eval(std::move(content)) == false)
        yyterminate();
    BEGIN(INITIAL);
  }
}

.|\n ECHO;

<<EOF>> {
  if(!m_fileStack.empty()) {
      yypop_buffer_state();
      auto file = m_fileStack.top();
      m_fileStack.pop();
      delete file;
  } else {
      yyterminate();
  }
}

%%

int main(int argc, char** argv) {
    namespace po = boost::program_options; 
    po::options_description desc{"Options"};
    std::string argsFile;
    desc.add_options()
      ("help,h", "Print this help message")
      ("args-file,f", po::value<std::string>()->required()->notifier([&argsFile](const std::string value) mutable { argsFile = std::move(value); }), "Specify args file path");
    po::variables_map varsMap;
    po::store(po::parse_command_line(argc, argv, desc), varsMap);
    if(varsMap.count("help")) {
        std::cout << "GMCR: gonapps' simple macro" << std::endl;
        std::cout << "It reads template file from stdin, prints processed result to stdout" << std::endl;
        std::cout << desc << std::endl;
        return 0;
    }
    po::notify(varsMap);

    std::unique_ptr<FlexLexer> lexer{new Gmcr::Lexer{std::move(argsFile)}};

    while(lexer->yylex() != 0) ;
        return 0;
}
