#include <iostream>
#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
class MyLexer : public yyFlexLexer {
public:
    MyLexer();
    virtual ~MyLexer();
    void hello();
};
