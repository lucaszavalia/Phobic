#ifndef TERM_HPP
#define TERM_HPP

#include "ast.hpp"
#include "symboltable.hpp"

namespace Phobic {
   class Term {
      private:
         AST tree;
         int type;

      public:
         Term() = default;
         Term(AST);
         void simplify();
   };

   template<typename T>
   T concretizeTerm(Term &, SymbolTable &);
}

#endif
