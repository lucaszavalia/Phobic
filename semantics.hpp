#ifndef SEMANTICS_HPP
#define SEMANTICS_HPP

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include "ast.hpp"

//quick hack
#define COMMA_SYM 12
#define COLON_SYM 13
#define BSLASH_SYM 14
#define DEFMACRO_SYM 15
#define SEND_SYM 46
#define RECEIVE_SYM 47
#define NEW_SYM 18
#define INT_TYPE 35
#define FLOAT_TYPE 36
#define BOOL_TYPE 37
#define CHAR_TYPE 38
#define STRING_TYPE 39
#define PROC_TYPE 40

namespace Phobic {
   class Scope {
      private:
         int begin;
         int end;

      public:
         Scope();
         Scope(int newBegin, int newEnd);
         int getBegin();
         int getEnd();
         void setBegin(int newBegin);
         void setEnd(int newEnd);
         friend class Semantics;
   };

   class ChanType {
      private:
         std::vector<int> type;

         void buildChanType(std::vector<int> & newVect, AST * subtree);

      public:
         ChanType();
         ChanType(AST * subtree);
         ChanType(std::vector<int> newType);
         bool operator==(const ChanType & obj) const;
         int getArity() const;
         int getSubtype(int pos) const;
         bool match(std::vector<int> & test);
         bool isEmpty();
         void print();
         friend class Semantics;
   };

   class VarDef {
      private:
         std::string name;
         int type;
         Scope scope;

      public:
         VarDef();
         VarDef(AST * subtree, int newBegin, int newEnd);
         bool match(std::string test, int pos);
         int getType();
         void print();
         friend class Semantics;
   };

   typedef std::vector<VarDef> VariableTable;

   class LVDef {
      private:
         std::string name;
         std::string src;
         int type;

      public:
         LVDef();
         LVDef(std::string newName, std::string newSrc, int newType);
         bool match(std::string);
         int getType();
         void print();
         friend class Semantics;
   };

   typedef std::vector<LVDef> LVTable;

   class ChanDef {
      private:
         std::string name;
         ChanType type;
         Scope scope;

      public:
         ChanDef();  
         ChanDef(AST * subtree, int newBegin, int newEnd);
         int getSubType(int pos) const;
         int getArity() const;
         bool match(std::string test, int pos);
         void print();
         friend class Semantics;
   };

   typedef std::vector<ChanDef> ChannelTable;

   class MacroDef {
      private:
         std::string name;
         VariableTable vt;
         ChannelTable ct;
         std::vector<AST *> order;
         AST * body;

         void buildLocals(VariableTable & newVT, ChannelTable & newCT, AST * subtree, int newBegin, int newEnd);
         void printBody(AST * subtree, int sp);

      public:
         MacroDef();
         MacroDef(AST * subtree);
         bool match(std::string);
         VariableTable getVT();
         ChannelTable getCT();
         std::string orderName(int pos);
         int orderId(int pos);
         int getBodyId();
         int getVarType(std::string test, int pos);
         ChanType getChanType(std::string test, int pos);
         int getNumChan();
         int getNumVar();
         bool isEmpty();
         void print();

         friend class Semantics;
   };

   typedef std::vector<MacroDef> MacroTable;

   class Semantics {
      private:
         enum AbridgedType {NIL, NUM, BOOL, STR};
         
         MacroTable mt;
         ChannelTable ct;
         LVTable vt;
         AST * tree;

         void buildMT(MacroTable & newMT, AST * subtree);
         void buildCT(ChannelTable & newCT, AST * subtree);
         void buildSubCT(ChannelTable & newCT, AST * subtree, int newBegin, int newEnd);
         void extractNames(AST * subtree, std::vector<std::string> & strs);
         void buildVT(LVTable & newVT, AST * subtree);
         void printRecurse(AST * subtree);
         int getAbridgedType(int symbol);
         bool isFloat(AST * node);
         std::string translateTypes(int symbol);
         void floatRecurse(AST * subtree, bool & val);
         void flatten(AST * subtree, std::vector<AST *> & subterms);
         void typeCheckTerm(AST * subtree);
         void typeCheckSend(AST * subtree);
         void typeCheckMacroApp(AST * subtree);
         void typeCheckDisjoin(AST * subtree);
         void typeCheckWait(AST * subtree);
         void applyTypeCheck1(AST * subtree);

      public:
         Semantics();
         Semantics(AST * subtree);

         int getLocalVarType(std::string test, int pos);
         void printLocalVars();
         ChanType getChanType(std::string test, int pos);
         MacroDef getMacroDef(std::string test);
         bool match(std::string test);
         void typeCheck1();
         void print();
   };

}

#endif
