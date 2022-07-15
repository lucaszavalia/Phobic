#ifndef AST_HPP
#define AST_HPP

#include <string>
#include <vector>
#include <iostream>
#include <fstream>

namespace Phobic {
   


   class AST {
      private:
         int id;
	 int tok;
         std::string raw;
         AST * parent;
         std::vector<AST *> children;

         void print(AST * subtree) {
            if (subtree == nullptr) {return;}
            std::cout << "id: " << subtree->id << "\ttoken: " << subtree->tok << "\traw string: " << subtree->raw << "\n";
            for (int i = 0; i < subtree->children.size(); i++) {print(subtree->children[i]);} 
         }

         void printDotLabels(AST * subtree, std::ofstream& ofs) {
            if (subtree == nullptr) {return;}
            ofs << "id" << subtree->id << " [label=\"" << subtree->raw << " ; " << subtree->tok << "\", fontname=\"monospace\"];\n";
            for (int i = 0; i < subtree->children.size(); i++) {
               printDotLabels(subtree->children[i], ofs);
            }
         }

         void printDotEdges(AST * subtree, std::ofstream& ofs) {
            if (subtree == nullptr) {return;}
            for (int i = 0; i < subtree->children.size(); i++) {
               ofs << "id" << subtree->id << "->id" << subtree->children[i]->id << ";\n";
               printDotEdges(subtree->children[i], ofs);
            }
         }

         int idCounter() {
            static int count = -1;
            count++;
            return count;
         }

      public:
         AST() {
            id = idCounter();
            tok = -1;
            raw = "";
            parent = nullptr;
         }

         AST(int newTok, std::string newRaw) {
            id = idCounter();
            tok = newTok;
            raw = newRaw;
            parent = nullptr;
         }

        ~AST() {
           freeAST();
        }

	void freeAST() {
            for (int i = 0; i < children.size(); i++) {
               delete children[i];
               children[i] = nullptr;
            }
	    children.clear();
            tok = -1;
            raw = "";
            parent = nullptr;
	}

        void addChild(int newToken, std::string newRaw) {
            AST * temp = new AST(newToken, newRaw);
            temp->parent = this;
            children.push_back(temp);
        }

        void concat(AST * subtree) {
            subtree->parent = this;
            children.push_back(subtree);
        }

        void printAST() {
            print(this);
        }

        void printASTdot() {
            std::ofstream ofs;
            ofs.open("AST.dot", std::ofstream::app);
            ofs << "digraph {\n";
            printDotLabels(this, ofs);
            printDotEdges(this, ofs);
            ofs << "}\n";
            ofs.close();
        }

   };

}

#endif
