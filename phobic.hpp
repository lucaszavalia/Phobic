#ifndef PHOBIC_HPP
#define PHOBIC_HPP

#include <string>
#include "phobic.tab.h"
#include "structures.h"

namespace phobic {
   class Phobic {
      private:
      struct AST * syntax_tree;
      semantics::SemanticAnalyzer sa;

      public:
      
      Phobic() {
         syntax_tree = NULL; 
      }

      Phobic(struct AST * newTree) {
         syntax_tree = newTree;
      }

      void analyzeSemantics() {
         sa = semantics::SemanticAnalyzer(syntax_tree);
         sa.typeCheck();
      }
   };
}

#endif
