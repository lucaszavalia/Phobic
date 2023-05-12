#ifndef ACTION_HPP
#define ACTION_HPP

#include <vector>
#include <string>
#include <cstdlib>
#include "term.hpp"

namespace Phobic {
   class Communication {
      private:
         std::string channel;
         Term & message; //consider making reference

      public:
         Communication() = default;
         Communication(AST);
   };

   class AgentCall {

   };

   struct Action {
      enum {COMM, CALL, STOP} tag;
      union {
         Communication c;
         AgentCall a;
         bool b;
      };
   };

   class ActionStack {
      private:
         std::vector<Action> stack;

      public:
         ActionStack() = default;
         ActionStack(AST);
         Action top();
         void pop();
         void executeTop();
   };
}


#endif
