all : gmcr
gmcr : lex.yy.cc lexer.cc
	$(CXX) -o gmcr lex.yy.cc lexer.cc -l boost_program_options -l lua5.3 -I /usr/include/lua5.3
lex.yy.cc : gmcr.ll
	flex gmcr.ll
clean :
	rm gmcr lex.yy.cc
