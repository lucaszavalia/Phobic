#ifndef DISJUNCTION_HPP
#define DISJUNCTION_HPP

#include <memory>
#include <utility>
#include <vector>
#include "action.hpp"
#include "ast.hpp"

namespace Phobic {
   class Conditional {
      private:
         AST subtree;

      public:
         Conditional() = default;
         Conditional(AST);
   };

   struct Trigger {
      enum {PROBABILITY, CONDITION} tag;
      union {
         float p;
         Conditional c;
      };
   };

   class Sum {
      private:
         Trigger & choice;
         ActionStack & actions;

      public:
         Sum() = default;
         Sum(AST);
         bool * evaluate();
   };

   class Disjunction {
      private:
         std::vector<Sum> choices;

      public:
         Disjunction() = default;
         Disjunction(AST);
         ActionStack select();
   };

   typedef std::vector<Disjunction> DisjunctionVector;
}

#endif
