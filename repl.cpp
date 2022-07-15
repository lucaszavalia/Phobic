#include <iostream>
#include "repl.h"

Phobic::Repl::Repl() : m_scanner(*this), m_parser(m_scanner, *this), m_location(0) {}

void Phobic::Repl::increaseLocation(unsigned int loc) {
   m_location += loc;
}

unsigned int Phobic::Repl::location() const {
   return m_location;
}

int Phobic::Repl::parse() {
   m_location = 0;
   return m_parser.parse();
}

void Phobic::Repl::print() {
   m_data.printTree();
   m_data.printTreeDot();
}

void Phobic::Repl::clear() {
   m_data.clear();
}

void Phobic::Repl::setAST(AST * tree) {
   m_data.setAST(tree);
}

void Phobic::Repl::switchInputStream(std::istream *is) {
   m_scanner.switch_streams(is, NULL);
}
