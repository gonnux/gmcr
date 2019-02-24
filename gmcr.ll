%{
//#define YY_DECL int Gmcr::Lexer::yylex()
#include "lexer.hh"
#include <iostream>
#include <memory>
#include <boost/program_options.hpp>
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
  \\\} yymore();
  \}\} { BEGIN(INITIAL); std::cout << "INCLUDE END[" << YYText() << "]" << std::endl; }
}

<INITIAL>\{\{[[:space:]] BEGIN(GMCR_STATE_MACRO);
<GMCR_STATE_MACRO>{
  [^\\}]* yymore();
  \\\} yymore();
  \}\} {
    std::string content = YYText();
    content = std::move(content.substr(0, content.size() - 2));
    if(this->eval(std::move(content)) == false)
        yyterminate();
    BEGIN(INITIAL);
  }
}

.|\n ECHO;

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
