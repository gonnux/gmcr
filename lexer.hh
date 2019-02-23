#include <iostream>
#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
class MyLexer : public yyFlexLexer {
public:
    MyLexer();
    virtual ~MyLexer();
    /*
    virtual void yy_switch_to_buffer(yy_buffer_state* newBuffer);
    virtual yy_buffer_state* yy_create_buffer(std::istream* s, int size);
    virtual yy_buffer_state* yy_create_buffer(std::istream& s, int size);
    virtual void yy_delete_buffer(yy_buffer_state*);
    virtual void yyrestart(std::istream* s);
    virtual void yyrestart(std::istream& s);
    virtual int yylex();
    virtual void switch_streams(std::istream*, std::ostream*);
    virtual void switch_streams(std::istream&, std::ostream&);
    */
};
