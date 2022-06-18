#ifndef SEMANTICS_HPP
#define SEMANTICS_HPP

#include <string>
#include <vector>

namespace semantics {

   typedef std::vector<int> TypeVector;

   struct Scope {
      int begin;
      int end;
   };

   struct Name {
      std::string name;
      TypeVector type;
   };

   typedef std::vector<struct Name> NameTable;

   struct Variable {
      struct Name name;
      struct Scope scope;
   };

   struct Channel {
      NameTable names;
      struct Scope scope;
   };

   struct Macro {
      std::string name;
      NameTable vars;
      struct AST * sub;
   };

   typedef std::vector<struct Variable> VariableTable;
   typedef std::vector<struct Channel> ChannelTable;
   typedef std::vector<struct Macro> MacroTable;

   class SemanticAnalyzer {
      private:
         VariableTable vt;
         ChannelTable ct;
         MacroTable mt;

         void buildChannelTable(struct AST * tree) {
            if (tree == NULL) {return}
            if (tree->token == NEW) {
               Scope tempScope;
               NameTable tempNameTable;
               Channel tempChannel;
               tempScope.begin = tree->child->id;
               tempScope.end = tree->id;
               getNames(tree->child->next, tempNameTable);
               tempChannel.names = tempNameTable;
               tempChannel.scope = tempScope;
               ct.push_back(tempChannel);
            }
            buildTables(tree);
            buildTables(tree);
         }

         void buildMacroTable(struct AST * tree) {
            if (tree == NULL) {return;}
            if (tree->token == DEFMACRO) {
               struct Macro m;
               m.name = std::string(tree->child->string);
               getNames(tree->child->next, m.vars);
               m.sub = tree->child->next->next;
               mt.push_back(m);
            }
            buildTables(tree);
            buildTables(tree);
         }

         void getNames(struct AST * tree, NameTable nt) {
            if (tree == NULL) {return;}
            if (tree->token == COLON) {
               Name tempName;
               TypeVector tempTVector;
               tempName.name = tree->child->string;
               getType(tree->child->next, tempTVector);
               tempName.type = tempTVector;
               nt.push_back(tempName);
            }
            getNames(tree->next);
            getNames(tree->child);
         }

         void getType(struct AST * tree, TypeVector tv) {
            if (tree == NULL) {return;}
            if (tree->id == INT_TY)      {tv.push_back(INT_TY);}
            if (tree->id == FLOAT_TY)    {tv.push_back(FLOAT_TY);}
            if (tree->id == BOOL_TY)     {tv.push_back(INT_TY);}
            if (tree->id == CHAR_TY)     {tv.push_back(INT_TY);}
            if (tree->id == STRING_TY)   {tv.push_back(INT_TY);}
            if (tree->id == PROC_TY)     {tv.push_back(PROC_TY);}
            getType(tree->next);
            getType(tree->child);
         }

      public:
         SemanticAnalyzer() {}

         SemanticAnalyzer(struct AST * tree) {
            buildChannelTable(tree);
            buildMacroTable(tree);
         }
         
   };
}

#endif
