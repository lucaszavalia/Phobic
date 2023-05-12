#ifndef SYMBOLTABLE_HPP
#define SYMBOLTABLE_HPP

#include <memory>
#include <vector>
#include <unordered_map>
#include "tree.hpp"
#include "ast.hpp"
#include "parser.hpp"

namespace Phobic {
/*   class Scope {
      private:
         int x;
         int y;

      public:
         Scope() {x = -1; y=-1;}
         Scope(int _x, int _y) {x = _x; y = _y;}
         Scope & operator=(const Scope & sc) {
            x = sc.getX();
            y = sc.getY();
            return *this;
         }

         int getX() const {return x;}
         int getY() const {return y;}
         bool isGlobal() const {return (x == -1 && y == -1);}

         bool operator==(const Scope & sc1) {
            if (this->x != sc1.getX()) {return false;}
            if (this->y != sc1.getY()) {return false;}
            return true;
         }

         bool operator!=(const Scope & sc1) {
            if (this->x == sc1.getX()) {return false;}
            if (this->y == sc1.getY()) {return false;}
            return true;
         }

         bool operator<=(const Scope & sc1) {
            if (this->x > sc1.getX()) {return false;}
            if (this->y > sc1.getY()) {return false;}
            return true;
         }

         bool operator>=(const Scope & sc1) {
            if (this->x < sc1.getX()) {return false;}
            if (this->y < sc1.getY()) {return false;}
            return true;
         }

         bool operator<(const Scope & sc1) {
            if (this->x >= sc1.getX()) {return false;}
            if (this->y >= sc1.getY()) {return false;}
            return true;
         }

         bool operator>(const Scope & sc1) {
            if (this->x <= sc1.getX()) {return false;}
            if (this->y <= sc1.getY()) {return false;}
            return true;
         }
   };*/

   /*
    * THIS IS VERY IMPORTANT
    * symbol table needs to be able to process receives
    * scope should proceed from the point where the receive occurs to the end of the agent's scope
    *
    * */

/*   class TypeData {
      private:
         std::string name;
         AST body;
         AST refinement;

      public:
         TypeData(AST subtree) {
            name = subtree->getFirst()->getData().getRaw();
            auto sndChild = subtree->getChild(1);
            if (sndChild->getData().getToken() != Parser::symbol_kind::S_WHERE) {
               refinement = nullptr;
               body = sndChild;
            }
            else {
               body = sndChild->getFirst();
               refinement = sndChild->getLast();
            }
         }

         bool hasRefinement() {
            if (refinement == nullptr) {return false;}
            return true;
         }

         void print() {
            std::cout << "Type: " << name << '\n';
         }
   }; 

   class AgentData {
      private:
         std::string name;
         AST vars;
         AST body;

      public:
         AgentData(AST subtree) {
            //rewrite section, don't use tree size, instead consider the token of the particular children
            auto fstChild = subtree->getFirst();
            name = fstChild->getData().getRaw();
            auto sndChild = subtree->getChild(1);
            auto sndTop = sndChild->getData().getToken();
            if (sndTop == Parser::symbol_kind::S_COMMA || sndTop == Parser::symbol_kind::S_COLON) {
               vars = sndChild;
               body = subtree->getChild(2);
            }
            else {
               vars = nullptr;
               body = sndChild;
            }
         }

         void print() {
            std::cout << "Agent: " << name << '\n';
         }
   };

   class ChannelData {
      private:
         std::string name;
         AST type;

      public:
         ChannelData(AST subtree) {
            name = subtree->getFirst()->getData().getRaw();
            type = subtree->getChild(1);
         }
 
         void print() {
            std::cout << "Channel: " << name << '\n';
         }
   };

   class ConstructorData {
      private:
         AST vars;
         AST body;

      public:
         ConstructorData(AST subtree) {
            auto fstChild = subtree->getFirst();
            auto topTok = fstChild->getData().getToken();
            if (topTok == Parser::symbol_kind::S_COMMA || topTok == Parser::symbol_kind::S_COLON) {
               vars = fstChild;
               body = subtree->getChild(1);
            }
            else {
               vars = nullptr;
               body = fstChild;
            }
         }
   };

   class ClassData {
      private:
         std::string name;
         AST inheritance;
         AST body;
         std::vector<ConstructorData> constructors;
         std::vector<AgentData> agents;
         std::vector<ChannelData> channels;

         void buildCont(AST subtree) {
            if (subtree->getData().getToken() == Parser::symbol_kind::S_CONSTRUCTOR) {
               ConstructorData cd = ConstructorData(subtree);
               constructors.push_back(cd);
            }
            if (subtree->getData().getToken() == Parser::symbol_kind::S_AGENT) {
               AgentData ad = AgentData(subtree);
               agents.push_back(ad);
            }
            if (subtree->getData().getToken() == Parser::symbol_kind::S_COLON) {
               ChannelData chd = ChannelData(subtree);
               channels.push_back(chd);
            }
         }

      public:
         ClassData(AST subtree) {
            auto firstData = subtree->getFirst()->getData();
            name = firstData.getRaw();
            if (firstData.getToken() == Parser::symbol_kind::S_PROVES) {
               inheritance = subtree->getChild(1);
               body = subtree->getChild(2);
            }
            else {
               inheritance = nullptr;
               body = subtree->getChild(1);
            }
            std::function<void(std::shared_ptr<Tree<NodeData>>)> build = [this](AST subtree){this->buildCont(subtree);};
            dfsMapT(body, build);
         }
   };

   class SymbolTable {
      private:
         std::vector<TypeData> types;
         std::vector<ClassData> classes;
         std::vector<AgentData> agents;
         std::vector<ChannelData> channels;

      public:
         SymbolTable() {}

         void addType(AST subtree) {
            TypeData td = TypeData(subtree);
            types.push_back(td); 
         }

         void addClass(AST subtree) {
            ClassData cd = ClassData(subtree);
            classes.push_back(cd);
         }

         void addAgent(AST subtree) {
            AgentData ad = AgentData(subtree);
            agents.push_back(ad);
         }

         void addChannel(AST subtree) {
            ChannelData chd = ChannelData(subtree);
            channels.push_back(chd);
         }
   };*/

   //pass one collect names for types and class, each classdef/typedef must be removed 
   /*class SymbolTableBuilder {
      private:
         void passOneNameBuilder(AST subtree, SymbolTable & st) {
            std::function<void(std::shared_ptr<Tree<NodeData>>, SymbolTable &)> fun = [](std::shared_ptr<Tree<NodeData>> tree, SymbolTable & symtbl) {
               if (tree->getData().getToken() == Parser::symbol_kind::S_CLASS) {
                  symtbl.addClass(tree);
               }
               if (tree->getData().getToken() == Parser::symbol_kind::S_TYPE) {
                  symtbl.addType(tree);
               }
            };
            dfsFoldT(subtree, st, fun);
         }

      void passTwoNameBuilder(AST subtree, SymbolTable & st) {std::cout << "phase 2 name construction unimplemented\n";}

   public:
      SymbolTableBuilder() = default;

      void operator()(AST subtree, SymbolTable & st) {
         passOneNameBuilder(subtree, st);
      }
   };*/

   class Scope {
      private:
         bool global = false;
         std::pair<int, int> coords;
         bool extrudable = true;
         std::vector<std::pair<int, int>> extensions;

      public:
         Scope() = default;

         Scope(int x, int y) {
            coords.first = x;
            coords.second = y;
         };

         void toggleExtrudable() {extrudable = !extrudable;}
         void toggleGlobal() {global = !global;}
         void extrude(int x, int y) {extensions.push_back(std::make_pair(x, y));}
         
         int getX() {return coords.first;}
         int getY() {return coords.second;}
         bool inScope(int pos) {
            if (global == true) {return true;}
            else {
               if (coords.first >= pos && coords.second <= pos) {return true;}
               for (auto & e : extensions) {
                  if (e.first >= pos && e.second <= pos) {
                     return true;
                  }
               }
            }
         }

         void print() {
            if (global == true) {std::cout << "global"; return;}
            std::cout << "{Begin: " << coords.first << ", End: " << coords.second << "} ";
            for (auto & e : extensions) {
               std::cout << "{Begin: " << coords.first << ", End: " << coords.second << "} ";
            }
         }
   };

   class TypeData {

   };

   class AgentData {

   };

   class ClassData {

   };

   class VariableData {

   };

   class ChannelData {

   };

   class SymbolTable {
      private:
         std::unordered_map<std::string, TypeData> types;
         std::unordered_map<std::string, AgentData> agents;
         std::unordered_map<std::string, ClassData> classes;
         std::unordered_map<std::string, VariableData> variables;
         std::unordered_map<std::string, ChannelData> channels;

      public:
         SymbolTable() = default;

         void addType(AST subtree) {

         }

         void addAgent(AST subtree) {

         }

         void addClass(AST subtree) {

         }

         void addVariable(AST subtree) {

         }

         void addChannel(AST subtree) {

         }

         bool find(std::string testString) {

         }

         std::shared_ptr<TypeData> getType(std::string name) {

         }

         std::shared_ptr<AgentData> getAgent(std::string name) {

         }

         std::shared_ptr<ClassData> getClass(std::string name) {

         }

         std::shared_ptr<VariableData> getVariable(std::string name) {

         }

         std::shared_ptr<ChannelData> getChannel(std::string name) {

         }
   };

   void inline passOneNameBuilder(AST subtree, SymbolTable & st) {
      std::function<void(std::shared_ptr<Tree<NodeData>>, SymbolTable &)> fun = [](std::shared_ptr<Tree<NodeData>> tree, SymbolTable & symbltbl) {
         switch (tree->getData().getToken()) {
            case Parser::symbol_kind::S_TYPE:
               symbltbl.addType(tree);
               break;
            case Parser::symbol_kind::S_AGENT:
               symbltbl.addAgent(tree);
               break;
            case Parser::symbol_kind::S_CLASS:
               symbltbl.addClass(tree);
               break;
            case Parser::symbol_kind::S_NEW:
               symbltbl.addChannel(tree);
               break;
            default:
               break;
         }
      };
      dfsFoldT(subtree, st, fun);     
   }
}

#endif
