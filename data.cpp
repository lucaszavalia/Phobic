#include "data.hpp"
#include "parser.hpp"

Phobic::Data::Data() {
   ast = nullptr;
   sms = Phobic::Semantics();
   exe = Phobic::Executor();
}

void Phobic::Data::setAST(Phobic::AST * tree) {ast = tree;}

void Phobic::Data::addNode(int token, std::string data) {
   ast->addChild(token, data);
}

void Phobic::Data::addSubtree(Phobic::AST * subtree) {
   ast->concat(subtree);
}

void Phobic::Data::printTree() {
   ast->printAST();
}

void Phobic::Data::printTreeDot() {
   ast->printASTdot();
}

void Phobic::Data::clear() {
   ast->freeAST();
}
