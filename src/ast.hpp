#ifndef AST_HPP
#define AST_HPP

#include <fstream>
#include <ostream>
#include <vector>
#include <string>
#include <memory>
#include <functional>
#include "tree.hpp"

namespace Phobic {
   enum LocalType {
      UNTYPEABLE,
      DEFERRED,
      INT,
      FLOAT,
      NUM,
      BOOL,
      CHAR,
      STRING,
      LEX,
      LIST,
      PROC,
      OBJ,
      TYPE,
      CLASS,
      TEMPLATE
   };

   class NodeData {
      private:
         int id = -1;
         int token = -1;
         int type = -1;
         std::string raw = "";

         int getNextId() {
            static int nextId = 0;
            return nextId++;
         }

      public:
         NodeData() {}
         NodeData(int _token, int _type, std::string _raw) : id(getNextId()), token(_token), type(_type), raw(_raw){}
         int getId() const {return id;}
         int getToken() const {return token;}
         int getType() const {return type;}
         std::string getRaw() const {return raw;}
         bool operator==(const NodeData & obj) const {
            return ((obj.getId() == id) &&
                     (obj.getToken() == token) &&
                     (obj.getType() == type) &&
                     (raw.compare(obj.getRaw()) == 0));
         }

         friend std::ostream & operator<<(std::ostream & output, const NodeData & nd) {
            output << "Node Data {ID: " << nd.getId() << ", Token: " << nd.getToken();
            output << ", Type: " << nd.getType() << ", Raw: " << nd.getRaw() << "}";
            return output;
         }
   };

   template class Tree<Phobic::NodeData>;
   typedef std::shared_ptr<Phobic::Tree<Phobic::NodeData>> AST;

   AST inline mkAST(int _token, int _type, std::string _raw) {
      NodeData nd = NodeData(_token, _type, _raw);
      return std::make_shared<Tree<NodeData>>(nd);
   }

   void inline printAST(Phobic::AST tree) {
      std::function<void(Phobic::AST, std::ostream &)> printer = [](Phobic::AST subtree, std::ostream & os) {
         if (subtree == nullptr) {std::cout << "ping ping pinguino\n"; return;}
         auto data = subtree->getData();
         os << data << "\n";
      };
      dfsPrinter(tree, std::cout, printer);
   }

   void inline printDotFile(Phobic::AST tree) {
      std::ofstream dotFile;
      dotFile.open("AST.dot", std::ostream::out | std::ostream::app);
      dotFile << "digraph {\n";
      std::function<void(Phobic::AST, std::ostream &)> labeller = [](Phobic::AST ast, std::ostream & os) {
         if (ast == nullptr) {return;}
         auto data = ast->getData();
         os << "id" << data.getId() << " [label=\"";
         os << "ID: " << data.getId() << " ; ";
         os << "TOKEN: "  << data.getToken() << " ; ";
         os << "TYPE: " << data.getType() << " ; "; 
         os << "RAW: " << data.getRaw();
         os << "\", fontname=\"monospace\"];\n";
      };
      std::function<void(Phobic::AST, std::ostream &)> connector = [](Phobic::AST ast, std::ostream & os) {
         if (ast->isLeaf()) {return;}
         auto data = ast->getData();
         for (int i = 0; i < ast->getSize(); i++) {
            auto temp = ast->getChild(i)->getData();
            os << "id" << data.getId() << "->";
            os << "id" << temp.getId() << ";\n";
         }
      };
      dfsPrinter<NodeData>(tree, dotFile, labeller);
      dfsPrinter<NodeData>(tree, dotFile, connector);
      dotFile << "}\n";
      dotFile.close();
   }
}

#endif
