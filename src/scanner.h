#ifndef SCANNER_H
#define SCANNER_H

//boilerplate code
#if ! defined(yyFlexLexerOnce)
#undef yyFlexLexer
#define yyFlexLexer Phobic_FlexLexer
#include <FlexLexer.h>
#endif

#undef YY_DECL
#define YY_DECL Phobic::Parser::symbol_type Phobic::Scanner::get_next_token()

#include "parser.hpp"

namespace Phobic {
   class Repl;
   class Scanner : public yyFlexLexer {
      private:
         Repl& m_repl;
      public:
         Scanner(Repl &repl) : m_repl(repl) {}
         virtual ~Scanner() {}
         virtual Phobic::Parser::symbol_type get_next_token();
   };
}

#endif
