ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif
all : gmcr
gmcr : lex.yy.cc lexer.cc lexer.hh
	$(CXX) -o gmcr lex.yy.cc lexer.cc -l boost_program_options -l lua5.3 -L /usr/lib/lua5.3 -I /usr/include/lua5.3
lex.yy.cc : gmcr.ll
	flex gmcr.ll
clean :
	rm gmcr lex.yy.cc
install : gmcr
	install -m 755 gmcr $(PREFIX)/bin/
