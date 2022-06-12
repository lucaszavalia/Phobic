#include <stdio.h>
#include "structures.h"
#include "phobic.tab.h"

int main() {
   extern struct AST * parsedTree;
   if (yyparse()) {printf("Parse Sucessful\n");}
   print_AST(parsedTree);
   print_AST_dot(parsedTree, "ast.dot");
   free_AST(parsedTree);
   return 0;
}
