#ifndef CONTROLLER_HPP
#define CONTROLLER_HPP

#include <memory>
#include "vector"
#include "disjunction.hpp"
#include "ast.hpp"

namespace Phobic {
   class Controller {
      protected:
         enum {STANDARD, GPU, MPI} type;
         DisjunctionVector disjuncts;

      public:
         virtual void parallelize(AST tree) = 0;
         virtual void schedule() = 0;
         int getType() {return (int)type;}
   };

   class standardController;
   class gpuController;
   class mpiController;

   typedef std::shared_ptr<Controller> ControllerPtr;
}

#endif
