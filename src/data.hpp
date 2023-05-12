#ifndef DATA_HPP
#define DATA_HPP

#include <functional>
#include "ast.hpp"
//#include "semantics.hpp"
#include "controller.hpp"
#include "parser.hpp"
#include "symboltable.hpp"

namespace Phobic {
   class Data {
      private:
         AST ast;
         SymbolTable st; 
         ControllerPtr exe;

      public:
        Data();
        AST getAST();
        void setAST(AST tree);
        void buildNames();
        void addSubtree(AST subtree);
        //void typeCheck();
        void printTree();
        void printTreeDot();
        //void printSemantics();
   };
}

#endif
