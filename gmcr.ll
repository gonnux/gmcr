%{
//#define YY_DECL int Gmcr::Lexer::yylex()
#include "lexer.hh"
#include <iostream>
#include <fstream>
#include <memory>
#include <boost/program_options.hpp>
#define GMCR_END "}}#"
%}
%option nodefault
%option noyywrap
%option c++
%option yyclass="Gmcr::Lexer"
%s GMCR_STATE_INCLUDE
%s GMCR_STATE_MACRO
GMCR_BEGIN #\{\{
GMCR_CONTENT .|\n
GMCR_ESCCHAR [^\\\}#]
GMCR_ESCAPE .?\\\}\}#
GMCR_END \}\}#
%%


{GMCR_BEGIN}include[[:space:]] BEGIN(GMCR_STATE_INCLUDE);
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
    auto buf = yy_create_buffer(*file, YY_BUF_SIZE);
    yypush_buffer_state(buf);
    m_fileStack.push(file);
    BEGIN(INITIAL);
  }
}

<INITIAL>{GMCR_BEGIN}[[:space:]] BEGIN(GMCR_STATE_MACRO);
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
      ("help", "Help")
      ("args-file,f", po::value<std::string>()->default_value("args.json")->notifier([&argsFile](const std::string value) mutable { argsFile = std::move(value); }), "ArgsFile");
    po::variables_map varsMap;
    po::store(po::parse_command_line(argc, argv, desc), varsMap);
    if(varsMap.count("help")) {
        std::cout << desc << std::endl;
        return 0;
    }
    po::notify(varsMap);

    std::unique_ptr<FlexLexer> lexer{new Gmcr::Lexer{std::move(argsFile)}};

    while(lexer->yylex() != 0) ;
        return 0;
}
