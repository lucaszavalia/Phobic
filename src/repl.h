#ifndef REPL_H
#define REPL_H

#include "scanner.h"
#include "parser.hpp"
#include "data.hpp"
#include "ast.hpp"

namespace Phobic {
   class Repl {
      private:
         Scanner m_scanner;
         Parser m_parser;
         Data m_data;
         unsigned int m_location;
         unsigned int location() const;
         void increaseLocation(unsigned int loc);
      public:
         Repl();
         int parse();
         void typeCheck();
         void switchInputStream(std::istream *is);
	      void print();
	      void clear();
	      void setAST(AST tree);
         friend class Parser;
         friend class Scanner;
   };       
}

#endif
