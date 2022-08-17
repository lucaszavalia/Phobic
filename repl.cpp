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
   auto result = m_parser.parse();
   m_data.setSemantics(m_data.getAST());
   return result;
}

void Phobic::Repl::typeCheck() { m_data.typeCheck(); }

void Phobic::Repl::print() {
   m_data.printTree();
   m_data.printTreeDot();
   m_data.printSemantics();
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
