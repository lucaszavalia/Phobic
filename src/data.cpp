#include "data.hpp"
#include "parser.hpp"
#include "ast.hpp"
#include "symboltable.hpp"

Phobic::Data::Data() {
   ast = nullptr;
   st = SymbolTable();
   exe = nullptr;
}

Phobic::AST Phobic::Data::getAST() {return ast;}

void Phobic::Data::setAST(Phobic::AST tree) {ast = tree;}

void Phobic::Data::buildNames() {
  /*Phobic::SymbolTableBuilder stb = SymbolTableBuilder();
  stb(ast,st);*/
  passOneNameBuilder(ast, st);
}

void Phobic::Data::addSubtree(Phobic::AST subtree) {
   ast->concat(subtree);
}

void Phobic::Data::printTree() {
   Phobic::printAST(ast);
}

void Phobic::Data::printTreeDot() {
   Phobic::printDotFile(ast);
}

/*void Phobic::Data::typeCheck() {
   sms.typeCheck1();
}*/

/*void Phobic::Data::printSemantics() {
   sms.print();
}*/

