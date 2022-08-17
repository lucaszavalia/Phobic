#include <iostream>
#include <string>
#include <vector>
#include "ast.hpp"
#include "parser.hpp"
#include "semantics.hpp"

Phobic::Scope::Scope() {
   begin = -1;
   end = -1;
}

Phobic::Scope::Scope(int newBegin, int newEnd) {
   begin = newBegin;
   end = newEnd;
   //stupid hack
   if (begin > end) {
      int temp = end;
      end = begin;
      begin = temp;
   }
}

int Phobic::Scope::getBegin() {return begin;}

int Phobic::Scope::getEnd() {return end;}

void Phobic::Scope::setBegin(int newBegin) {begin = newBegin;}

void Phobic::Scope::setEnd(int newEnd) {end = newEnd;}

void Phobic::ChanType::buildChanType(std::vector<int> & newVect, AST * subtree) { 
   if (subtree->isLeaf()) {
      int temp = subtree->getTok();
      newVect.push_back(temp);
      return;
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      buildChanType(newVect, subtree->getChild(i));
   }
}

Phobic::ChanType::ChanType() {}

Phobic::ChanType::ChanType(AST * subtree) {
   buildChanType(type, subtree);
}

Phobic::ChanType::ChanType(std::vector<int> newType) {type = newType;}

bool Phobic::ChanType::operator==(const Phobic::ChanType & obj) const {
   if (type.size() != obj.getArity()) {return false;}
   for (int i = 0; i < type.size(); i++) {
      if (type[i] != obj.getSubtype(i)) {return false;}
   }
   return true;
}

int Phobic::ChanType::getArity() const {return type.size();}

int Phobic::ChanType::getSubtype(int pos) const {
   if (pos < 0 || pos >= type.size()) {return -1;}
   return type[pos];
}

bool Phobic::ChanType::match(std::vector<int> & test) {
   if (test.size() != type.size()) {return false;}
   for (int i = 0; i < test.size(); i++) {
      if (test[i] != type[i]) {return false;}
   } 
   return true;
}

bool Phobic::ChanType::isEmpty() {return type.empty();}

void Phobic::ChanType::print() {
   if (type.empty()) {
      std::cout << "[]";
      return;
   }
   std::cout << "[" << type[0];
   for (int i = 1; i < type.size(); i++) {
      std::cout << "," << type[i];
   }
   std::cout << "]";
}

Phobic::VarDef::VarDef() {
   name = "";
   type = -1;
   scope = Phobic::Scope();
}

Phobic::VarDef::VarDef(AST * subtree, int newBegin, int newEnd) {
   name = subtree->getChild(0)->getRaw();
   type = subtree->getChild(1)->getTok();
   scope = Phobic::Scope(newBegin, newEnd);
}

bool Phobic::VarDef::match(std::string test, int pos) {
   if (name.size() != test.size()) {return false;}
   for (int i = 0; i < name.size(); i++) {
      if (name[i] != test[i]) {return false;}
   }
   if (pos < scope.getBegin() || pos > scope.getEnd()) {return false;}
   return true;
}

int Phobic::VarDef::getType() {return type;}

void Phobic::VarDef::print() {
   std::cout << "VarDef {" << name << ", " << type << ", (" 
             << scope.getBegin() << ", " << scope.getEnd() << ")}\n";
}

Phobic::LVDef::LVDef() {
   name = "";
   src = "";
   type = -1;
}

Phobic::LVDef::LVDef(std::string newName, std::string newSrc, int newType) {
   name = newName;
   src = newSrc;
   type = newType;
}

bool Phobic::LVDef::match(std::string test) {
   if (name.size() != test.size()) {return false;}
   for (int i = 0; i < name.size(); i++) {
      if (name[i] != test[i]) {return false;}
   }
   return true;
}

int Phobic::LVDef::getType() {return type;}

void Phobic::LVDef::print() {
   std::cout << "LVDef {" << name << ", " << src << ", " << type << "}\n";
}

Phobic::ChanDef::ChanDef() {
   name = "";
   scope = Phobic::Scope();
}

Phobic::ChanDef::ChanDef(AST * subtree, int newBegin, int newEnd) {
   name = subtree->getChild(0)->getRaw();
   std::vector<int> temp;
   type = ChanType(subtree->getChild(1));
   scope = Phobic::Scope(newBegin, newEnd);
}

int Phobic::ChanDef::getSubType(int pos) const {
   if (pos >= type.getArity() || pos < 0) {return 0;}
   return type.getSubtype(pos);
}

int Phobic::ChanDef::getArity() const {return type.getArity();}

bool Phobic::ChanDef::match(std::string test, int pos) {
   //stupid manual implementation because str compare don't wanna work
   bool strMatch = true;
   if (test.size() == name.size()) {
      for (int i = 0; i < name.size(); i++) {
         if (name[i] != test[i]) {strMatch = false;}
      }
   }
   else {return false;}
   if (strMatch) {
      if (pos >= scope.getBegin() && pos <= scope.getEnd()) {return true;}
   }
   return false;
}

void Phobic::ChanDef::print() {
   std::cout << "ChanDef {" << name << ", ";
   type.print();
   std::cout << ", (" << scope.getBegin() << ", " << scope.getEnd() << ")}\n";
}

void Phobic::MacroDef::buildLocals(VariableTable & newVT, ChannelTable & newCT, AST * subtree, int newBegin, int newEnd) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == COLON_SYM) {
      auto temp = Phobic::VarDef(subtree, newBegin, newEnd);
      order.push_back(subtree);
      newVT.push_back(temp); 
   }
   if (subtree->getTok() == -1*COLON_SYM) {
      auto temp = Phobic::ChanDef(subtree, newBegin, newEnd);
      order.push_back(subtree);
      newCT.push_back(temp);
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      buildLocals(vt, ct, subtree->getChild(i), newBegin, newEnd);
   }
}

void Phobic::MacroDef::printBody(Phobic::AST * subtree, int sp) {
   if (subtree->isLeaf()) {
      std::cout << std::string(sp, ' ');
      std::cout << "(" << subtree->getId() << ", ";
      std::cout << subtree->getRaw() << ", ";
      std::cout << subtree->getTok() << ")\n";
      return;
   }
   std::cout << std::string(sp, ' ');
   std::cout << "(" << subtree->getId() << ", ";
   std::cout << subtree->getRaw() << ", ";
   std::cout << subtree->getTok() << ")\n";
   for (int i = 0; i < subtree->getSize(); i++) {
      printBody(subtree->getChild(i), sp+2);
   }
}

Phobic::MacroDef::MacroDef() {
   name = "";
   body = nullptr;
}

Phobic::MacroDef::MacroDef(AST * subtree) {
   name = subtree->getRaw();
   buildLocals(vt, ct, subtree->getChild(0), subtree->getId(), subtree->getChild(1)->getId());
   body = subtree->getChild(1);
}

bool Phobic::MacroDef::match(std::string test) {
   //stupid manual implementation because str compare don't wanna work
   if (test.size() != name.size()) {return false;}
   for (int i = 0; i < name.size(); i++) {
      if (name[i] != test[i]) {return false;}
   }
   return true;
}

std::string Phobic::MacroDef::orderName(int pos) {
   if (pos < 0 || pos >= order.size()) {return "";}
   auto treeVal = order[pos];
   return treeVal->getChild(0)->getRaw();
}

int Phobic::MacroDef::orderId(int pos) {
   if (pos < 0 || pos >= order.size()) {return -1;}
   auto treeVal = order[pos];
   return treeVal->getChild(0)->getId();
}

int Phobic::MacroDef::getBodyId() {return body->getId();}

int Phobic::MacroDef::getVarType(std::string test, int pos) {
   for (auto & it : vt) {
      if (it.match(test, pos)) {return it.getType();}
   }
   return -1;
}

Phobic::ChanType Phobic::MacroDef::getChanType(std::string test, int pos) {
   std::vector<int> newType;
   for (auto & it : ct) {
      if (it.match(test, pos)) {
         for (int i = 0; i < it.getArity(); i++) {
            newType.push_back(it.getSubType(i));
         }
      }
   }
   return ChanType(newType);
}

Phobic::VariableTable Phobic::MacroDef::getVT() {return vt;}

Phobic::ChannelTable Phobic::MacroDef::getCT() {return ct;}

int Phobic::MacroDef::getNumChan() {return ct.size();}

int Phobic::MacroDef::getNumVar() {return vt.size();}

bool Phobic::MacroDef::isEmpty() {
   if (body == NULL) {return true;}
   return false;
}

void Phobic::MacroDef::print() {
   std::cout << "MacroDef {\n";
   std::cout << "  Name: " << name << "\n";
   std::cout << "  Variables {\n";
   for (auto & it : vt) {
      std::cout << "    ";
      it.print();
      std::cout << "\n";
   }
   std::cout << "  }\n";
   std::cout << "  Channels {\n";
   for (auto & it : ct) {
      std::cout << "    ";
      it.print();
      std::cout << "\n";
   }
   std::cout << "  }\n";
   std::cout << "  Body {\n";
   printBody(body, 4);
   std::cout << "  }\n";
   std::cout << "}\n";
}

void Phobic::Semantics::buildMT(MacroTable & newMT, AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == DEFMACRO_SYM) {
      auto temp = Phobic::MacroDef(subtree);
      newMT.push_back(temp);
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      buildMT(newMT, subtree->getChild(i));
   }
}

void Phobic::Semantics::buildCT(ChannelTable & newCT, AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == NEW_SYM) {
      auto lhs = subtree->getChild(0);
      auto rhs = subtree->getChild(1);
      buildSubCT(newCT, subtree->getChild(0), lhs->getId(), rhs->getId());
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      buildCT(newCT, subtree->getChild(i));
   }
}

void Phobic::Semantics::buildSubCT(ChannelTable & newCT, AST * subtree, int newBegin, int newEnd) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == -1*COLON_SYM) {
      auto temp = Phobic::ChanDef(subtree, newBegin, newEnd);
      newCT.push_back(temp);
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      buildSubCT(newCT, subtree->getChild(i), newBegin, newEnd);
   }
}

void Phobic::Semantics::extractNames(AST * subtree, std::vector<std::string> & strs) {
   if (subtree->isLeaf()) {
      strs.push_back(subtree->getRaw()); //hacky af, redo this
      return;
   }
   if (subtree->getTok() != Phobic::Parser::symbol_kind::S_COMMA) strs.push_back(subtree->getRaw());
   for (int i = 0; i < subtree->getSize(); i++) {
      extractNames(subtree->getChild(i), strs);
   }
}

void Phobic::Semantics::buildVT(LVTable & newVT, AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_RECEIVE) {
      std::string chanName = subtree->getRaw();
      int chanId = subtree->getId();
      std::vector<std::string> localNames;
      extractNames(subtree->getChild(0), localNames);
      for (auto & it : ct) {
         if (it.match(chanName, chanId)) {
            for (int i = 0; i < it.getArity(); i++) {
               auto newLV = LVDef(localNames[i], chanName, it.getSubType(i));
               newVT.push_back(newLV);
            }
         }
      }
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      buildVT(newVT, subtree->getChild(i));
   }
}

void Phobic::Semantics::printRecurse(AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == DEFMACRO_SYM) { //for whatever reason the parser sees ":" and "::" as the same
      auto temp = Phobic::MacroDef(subtree);
      temp.print();
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      printRecurse(subtree->getChild(i));
   }
}

Phobic::Semantics::Semantics() {tree = nullptr;}

Phobic::Semantics::Semantics(AST * subtree) {
   tree = subtree;
   buildMT(mt, subtree);
   buildCT(ct, subtree);
   buildVT(vt, subtree);
}

int Phobic::Semantics::getAbridgedType(int symbol) {
   switch (symbol) {
      case Phobic::Parser::symbol_kind::S_ADD:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_SUB:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_MUL:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_DIV:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_MOD:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_INT:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_FLOAT:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_AND:
         return BOOL;
         break;
      case Phobic::Parser::symbol_kind::S_OR:
         return BOOL;
         break;
      case Phobic::Parser::symbol_kind::S_NOT:
         return BOOL;
         break;
      case Phobic::Parser::symbol_kind::S_TRUE:
         return BOOL;
         break;
      case Phobic::Parser::symbol_kind::S_FALSE:
         return BOOL;
         break;
      case -1*Phobic::Parser::symbol_kind::S_ADD:
         return STR;
         break;
      case Phobic::Parser::symbol_kind::S_CHAR:
         return STR;
         break;
      case Phobic::Parser::symbol_kind::S_STRING:
         return STR;
         break;
      case Phobic::Parser::symbol_kind::S_INT_T:
         return NUM;
         break;      
      case Phobic::Parser::symbol_kind::S_FLOAT_T:
         return NUM;
         break;
      case Phobic::Parser::symbol_kind::S_BOOL_T:
         return BOOL;
         break;
      case Phobic::Parser::symbol_kind::S_CHAR_T:
         return STR;
         break;
      case Phobic::Parser::symbol_kind::S_STRING_T:
         return STR;
         break;
      default:
         return NIL;
         break;
   }
}

bool Phobic::Semantics::isFloat(Phobic::AST * node) {
   int symbol = node->getTok();
   switch (symbol) {
      case Phobic::Parser::symbol_kind::S_FLOAT:
         return true;
         break;
      case Phobic::Parser::symbol_kind::S_FLOAT_T:
         return true;
         break;
      default: {
         int result = getLocalVarType(node->getRaw(), node->getId());
         if (result == Phobic::Parser::symbol_kind::S_FLOAT_T) {return true;}
         break;
      }
   }
   return false;
}

std::string Phobic::Semantics::translateTypes(int symbol) {
   switch(symbol) {
      case BOOL:
         return "Bool";
         break;
      case NUM:
         return "Numeric";
         break;
      case STR:
         return "Lexical";
         break;
      case NIL:
         return "Process"; //hacky but whatever
         break; 
      case Phobic::Parser::symbol_kind::S_CHAR_T:
         return "Char";
         break;
      case Phobic::Parser::symbol_kind::S_STRING_T:
         return "String";
         break;
      case Phobic::Parser::symbol_kind::S_PROC_T:
         return "Process";
         break;
      default:
         return "Unknown";
         break;
   }
}

void Phobic::Semantics::floatRecurse(Phobic::AST * subtree, bool & val) {
   if (subtree->isLeaf()) {
      val = val | isFloat(subtree);
      return;
   }
   val = val | isFloat(subtree);
   for (int i = 0; i < subtree->getSize(); i++) {
      floatRecurse(subtree->getChild(i), val);
   }
}

void Phobic::Semantics::flatten(Phobic::AST * subtree, std::vector<Phobic::AST *> & subterms) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_COMMA) {
      auto lhs = subtree->getChild(0);
      auto rhs = subtree->getChild(1);
      if (lhs->getTok() != Phobic::Parser::symbol_kind::S_COMMA) {
         subterms.push_back(lhs);
      }
      if (rhs->getTok() != Phobic::Parser::symbol_kind::S_COMMA) {
         subterms.push_back(rhs);
      }
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      flatten(subtree->getChild(i), subterms);
   }
}

void Phobic::Semantics::typeCheckTerm(Phobic::AST * subtree) {
   //printLocalVars();
   if (subtree->isLeaf()) {return;}
   int aType = getAbridgedType(subtree->getTok());
   if (aType != NIL) {
      for (int i = 0; i < subtree->getSize(); i++) {
         auto cur = subtree->getChild(i);
         int newAType = getAbridgedType(cur->getTok());
         if (newAType == NIL) {
            newAType = getLocalVarType(cur->getRaw(), cur->getId());
            newAType = getAbridgedType(newAType);
            if (newAType == NIL) {
               std::cerr << cur->getRaw() << " is undeclared\n";
               exit(1);
            }
         }
         if (newAType != aType) {
            std::cerr << "Could not match expected type " << aType;
            std::cerr << " with actual type " << newAType << "\n";
            exit(1);
         }
      }
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      typeCheckTerm(subtree->getChild(i));
   }
}

void Phobic::Semantics::typeCheckSend(Phobic::AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_SEND) {
      //get corresponding channel type and collect relevant subterms
      auto types = getChanType(subtree->getRaw(), subtree->getId());
      std::vector<Phobic::AST *> subterms;
      flatten(subtree->getChild(0), subterms);
      //case when there is only one subterm
      if (subterms.empty()) {
         auto lhs = subtree->getChild(0);
         typeCheckTerm(lhs);
         int actualType = getAbridgedType(lhs->getTok());
         //case when lhs has a variable
         if (actualType == NIL) {
            actualType = getAbridgedType(getLocalVarType(lhs->getRaw(), lhs->getId()));
         }
         int expectedType = getAbridgedType(types.getSubtype(0));
         if (actualType != expectedType) {
            std::cerr << "Could not match expected type " << expectedType;
            std::cerr << " with actual type " << actualType;
            std::cerr << " in position 0 of channel " << subtree->getRaw();
            std::cerr << "\n";
            exit(1);
         }
         if (types.getSubtype(0) == Phobic::Parser::symbol_kind::S_INT_T) {
            bool actualFloat = false;
            floatRecurse(lhs, actualFloat);
            if (actualFloat == true) {
               std::cerr << "Could not match expected type Int with actual type Float";
               std::cerr << " in position 0 of channel " << subtree->getRaw() << "\n";
               exit(1);
            }
         }  
         if (types.getSubtype(0) == Phobic::Parser::symbol_kind::S_CHAR_T) {
            if (lhs->getTok() != Phobic::Parser::symbol_kind::S_CHAR) {
               if (getLocalVarType(lhs->getRaw(), lhs->getId()) != Phobic::Parser::symbol_kind::S_CHAR_T) {
                  std::cerr << "Could not match expected type Char with actual type String";
                  std::cerr << " position 0 of channel " << subtree->getRaw() << "\n";
                  exit(1);
               }
            }
         }
      }
      //compare number of arguments
      if (subterms.size() != types.getArity() && !subterms.empty()) {
         std::cerr << "Incorrect number of arguments, needed ";
         std::cerr << types.getArity() << " arguments but ";
         if (subterms.empty()) {std::cerr << "1 was provided\n";}
         else {std::cerr << subterms.size() << " were provided\n";}
         exit(1);
      }
      //case when there is more than one relevant subterm
      for (int i = 0; i < subterms.size(); i++) {
         auto cur = subterms[i];
         typeCheckTerm(cur);
         int actualType = getAbridgedType(cur->getTok());
         //case when cur is a variable
         if (actualType == NIL) {
            actualType = getAbridgedType(getLocalVarType(cur->getRaw(), cur->getId()));
         }
         int expectedType = getAbridgedType(types.getSubtype(i));
         if (actualType != expectedType) {
            std::cerr << "Could not match expected type " << expectedType;
            std::cerr << " with actual type " << actualType;
            std::cerr << " in position 0 of channel " << subtree->getRaw();
            std::cerr << "\n";
            exit(1);
         }
         if (types.getSubtype(i) == Phobic::Parser::symbol_kind::S_INT_T) {
            bool actualFloat = false;
            floatRecurse(cur, actualFloat);
            if (actualFloat == true) {
               std::cout << "Type conflict, expecting Int but Float provided\n";
            }
         }
         if (types.getSubtype(i) == Phobic::Parser::symbol_kind::S_CHAR_T) {
            if (cur->getTok() != Phobic::Parser::symbol_kind::S_CHAR) {
               if (getLocalVarType(cur->getRaw(), cur->getId()) != Phobic::Parser::symbol_kind::S_CHAR_T) {
                  std::cerr << "Type conflict, expecting character\n";
                  exit(1);
               }
            }
         }
      }
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      typeCheckSend(subtree->getChild(i));
   }
}

//rewrite
void Phobic::Semantics::typeCheckMacroApp(Phobic::AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_MAPP) {
      //get macro and test if it exists
      std::string name = subtree->getRaw();
      auto lhs = subtree->getChild(0);
      auto cur = getMacroDef(name);
      if (cur.isEmpty()) {
         std::cerr << "Macro \"" << name;
         std::cerr << "\" not found\n";
         exit(1);
      }
      //test if macro has no parameters
      int numArgs = cur.getNumChan() + cur.getNumVar();
      std::vector<Phobic::AST *> subterms;
      flatten(lhs, subterms);
      if (numArgs == 0) {
         if (subtree->getSize() != 1) {
            std::cerr << "Application of \"" << name;
            std::cerr << "\" requires 0 arguments but more were provided\n";
            exit(1);
         }
      }
      else if (numArgs == 1) {
         std::cout << "Current data {Token: " << lhs->getTok();
         std::cout << ", ID: " << lhs->getId();
         std::cout << ", Raw " << lhs->getRaw();
         std::cout << "}\n";
         typeCheckTerm(lhs);
         auto tempVar = cur.orderName(0);
         int rawExpectedType = getLocalVarType(tempVar, cur.getBodyId());
         if (rawExpectedType == -1) {
            auto expectedChanType = getChanType(tempVar, cur.getBodyId());
            auto actualChanType = getChanType(lhs->getRaw(), cur.getBodyId());
            if (!(expectedChanType == actualChanType)) {
               std::cerr << "Could not find channel " << lhs->getRaw() << "\n";
               exit(1);
            }
         }
         else {
            int expectedType = getAbridgedType(rawExpectedType);
            typeCheckTerm(lhs);
            int actualType = getAbridgedType(lhs->getTok());
            if (actualType == NIL) {
               actualType = getAbridgedType(getLocalVarType(lhs->getRaw(), lhs->getId()));
            }
            if (expectedType != actualType) {
               std::cerr << "Could not match expected type " << expectedType;
               std::cerr << " with actual type " << actualType;
               std::cerr << " in position 0 of channel " << subtree->getRaw();
               std::cerr << "\n";
               exit(1);
            }
            if (rawExpectedType == Phobic::Parser::symbol_kind::S_INT_T) {
               bool actualFloat = false;
               floatRecurse(lhs, actualFloat);
               if (actualFloat == true) {
                  std::cerr << "Type conflict, expecting Int but Float provided\n";
                  exit(1);
               }              
            }
            if (rawExpectedType == Phobic::Parser::symbol_kind::S_CHAR_T) {
               if (lhs->getTok() != Phobic::Parser::symbol_kind::S_CHAR) {
                  if (getLocalVarType(lhs->getRaw(), lhs->getId()) != Phobic::Parser::symbol_kind::S_CHAR_T) {
                     std::cerr << "Type conflict, expecting character\n";
                     exit(1);
                  }
               }
            }
         }
      }
      else {
         if (subterms.size() != numArgs) {
            std::cerr << "Application of \"" << name;
            std::cerr << "\" requires " << numArgs;
            std::cerr << " arguments but " << subterms.size();
            std::cerr << " were provided\n";
            exit(1);
         }
         for (int i = 0; i < subterms.size(); i++) {
            auto it = subterms[i];
            std::cout << "Current data {Token: " << it->getTok();
            std::cout << ", ID: " << it->getId();
            std::cout << ", Raw " << it->getRaw();
            std::cout << "}\n";
            auto tempVar = cur.orderName(i);
            int rawExpectedType = getLocalVarType(tempVar, cur.getBodyId());
            if (rawExpectedType == -1) {
               auto expectedChanType = getChanType(tempVar, cur.getBodyId());
               auto actualChanType = getChanType(it->getRaw(), cur.getBodyId());
               if (!(expectedChanType == actualChanType)) {
                  std::cerr << "Could not find channel " << it->getRaw() << "\n";
                  exit(1);
               }              
            }
            else {
               int expectedType = getAbridgedType(rawExpectedType);
               typeCheckTerm(it);
               int actualType = getAbridgedType(it->getTok());
               if (actualType == NIL) {
                  actualType = getAbridgedType(getLocalVarType(it->getRaw(), it->getId()));
               }
               if (expectedType != actualType) {
                  std::cerr << "Could not match expected type " << expectedType;
                  std::cerr << " with actual type " << actualType;
                  std::cerr << " in position 0 of channel " << subtree->getRaw();
                  std::cerr << "\n";
                  exit(1);
               }
               if (rawExpectedType == Phobic::Parser::symbol_kind::S_INT_T) {
                  bool actualFloat = false;
                  floatRecurse(it, actualFloat);
                  if (actualFloat == true) {
                     std::cerr << "Type conflict, expecting Int but Float provided\n";
                     exit(1);
                  }              
               }
               if (rawExpectedType == Phobic::Parser::symbol_kind::S_CHAR_T) {
                  if (it->getTok() != Phobic::Parser::symbol_kind::S_CHAR) {
                     if (getLocalVarType(it->getRaw(), it->getId()) != Phobic::Parser::symbol_kind::S_CHAR_T) {
                        std::cerr << "Type conflict, expecting character\n";
                        exit(1);
                     }
                  }
               }
            }
         }
      }
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      typeCheckMacroApp(subtree->getChild(i));
   }
}

void Phobic::Semantics::typeCheckDisjoin(Phobic::AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_PDISJOIN) {
      if (subtree->getSize() == 3) {
         auto probability = subtree->getChild(1);
         typeCheckTerm(probability);
         bool res;
         floatRecurse(probability, res);
         if (res == false || getAbridgedType(probability->getTok()) != NUM) {
            std::cerr << "Term in probabilistic disjunction is not a floating point number\n";
            exit(1);
         }
      }
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      typeCheckDisjoin(subtree->getChild(i));
   }
}

void Phobic::Semantics::typeCheckWait(Phobic::AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_WAIT) {
      typeCheckTerm(subtree->getChild(0));
      int type = getAbridgedType(subtree->getChild(0)->getTok());
      bool val = false;
      floatRecurse(subtree->getChild(0), val);
      if (val == true || type != NUM) {
         std::cerr << "Term in wait is not an integer\n";
         exit(1);
      }  
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      typeCheckWait(subtree->getChild(i));
   }
}

int Phobic::Semantics::getLocalVarType(std::string test, int pos) {
   for (auto & it : vt) {
      if (it.match(test)) {return it.getType();}
   }
   for (auto & it : mt) {
      auto localVT = it.getVT();
      pos = it.getBodyId();
      for (auto & is : localVT) {
         if (is.match(test, pos)) {return is.getType();}
      }
   }
   return -1;
}

void Phobic::Semantics::printLocalVars() {
   for (auto & it : vt) {
      std::cout << it.name << ":" << it.type << "\n";
   }
   for (auto & it : mt) {
      auto localVT = it.getVT();
      for (auto & is : localVT) {
         std::cout << is.name << ":" << is.type << "\n";
      }
   }
}

Phobic::ChanType Phobic::Semantics::getChanType(std::string test, int pos) {
   for (auto & it : ct) {
      if (it.match(test, pos)) {return it.type;}
   }
   for (auto & it : mt) {
      pos = it.getBodyId();
      auto temp = it.getChanType(test, pos);
      if (!(temp == ChanType())) {return temp;}
   }
   return ChanType();
}

Phobic::MacroDef Phobic::Semantics::getMacroDef(std::string test) {
   for (auto & it : mt) {
      if (it.match(test)) {return it;}
   }
   return Phobic::MacroDef();
}

/*bool match(std::string test) {

}*/

void Phobic::Semantics::applyTypeCheck1(Phobic::AST * subtree) {
   if (subtree->isLeaf()) {return;}
   if (subtree->getTok() == Phobic::Parser::symbol_kind::S_SEND) {
      typeCheckSend(subtree);
   }
   for (int i = 0; i < subtree->getSize(); i++) {
      applyTypeCheck1(subtree->getChild(i));
   }
}

void Phobic::Semantics::typeCheck1() {
   //applyTypeCheck1(tree);
   typeCheckSend(tree);
   typeCheckMacroApp(tree);
   typeCheckDisjoin(tree);
   typeCheckWait(tree);
}


void Phobic::Semantics::print() {
   std::cout << "\n==== Macro Definitions ====\n";
   for (auto & it : mt) {
      it.print();
      std::cout << "\n";
   } 
   std::cout << "===========================\n\n";
   std::cout << "=== Channel Definitions ===\n";
   for (auto & it : ct) {
      it.print();
      std::cout << "\n";
   }
   std::cout << "===========================\n\n";
   std::cout << "===== Local Variables =====\n";
   for (auto it : vt) {
      it.print();
      std::cout << "\n";
   }
   std::cout << "===========================\n\n";
}
