#ifndef PHOBIC_HPP
#define PHOBIC_HPP

#include "ast.hpp"
#include "semantics.hpp"
#include "executor.hpp"
#include "parser.hpp"

namespace Phobic {
   class Data {
      private:
         AST * ast;
         Semantics sms;
         Executor exe;

      public:
        Data();
        AST * getAST();
        void setAST(AST * tree);
        void setSemantics(AST * tree);
        void addNode(int token, std::string data);
        void addSubtree(AST * subtree);
        void typeCheck();
        void printTree();
        void printTreeDot();
        void printSemantics();
	     void clear();
   };
}

#endif
