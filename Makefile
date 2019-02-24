all : gmcr
gmcr : lex.yy.cc
	$(CXX) -o gmcr lex.yy.cc lexer.cc
lex.yy.cc : gmcr.ll
	flex gmcr.ll
clean :
	rm gmcr lex.yy.cc
