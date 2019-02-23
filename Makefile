all : test
test : lex.yy.c
	$(CXX) -o test lex.yy.cc
lex.yy.c : test.l
	flex test.l
clean :
	rm test lex.yy.cc
