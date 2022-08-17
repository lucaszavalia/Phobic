#include <iostream>
#include "scanner.h"
#include "parser.hpp"
#include "repl.h"

int main(int argc, char **argv) {
   Phobic::Repl r;
   int res = r.parse();
   r.print();
   r.typeCheck();
   std::cout << "Parse complete\n";
   return res;
}
