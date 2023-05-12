#ifndef BASE_HPP
#define BASE_HPP

#include <memory>
#include <functional>
#include <iostream>
#include <ostream>
#include <fstream>
#include <vector>
#include <string>

namespace Phobic {
   template <class T>
   class Tree {
      private:
         T data;
         std::shared_ptr<Tree> parent = nullptr;
         std::vector<std::shared_ptr<Tree>> children;
   
      public:
         Tree() {}
         Tree(const Tree &) = default;
         Tree& operator=(const Tree &) = default;
         ~Tree() = default;
         Tree(T & newData) {data = newData;}
         Tree(T & newData, Tree<T> * p) {data = newData; parent = std::make_shared<Tree<T>>(*p);}
   
         void addChild(T & newData) {
            /*auto temp = Tree<T>(newData);
            auto tempPtr = std::make_shared(temp);
            children.push_back(tempPtr);*/
            children.emplace_back((new Tree<T>(newData, this)));
         }
   
         void concat(std::shared_ptr<Tree> & subtree) {
            subtree->parent = std::make_shared<Tree<T>>(*this);
            children.push_back(subtree);
         }
         int getSize() const {return children.size();}
         bool isLeaf() const {return children.empty();}
         T getData() const {return data;}
         std::shared_ptr<Tree> & getFirst() {return *children.begin();}
         std::shared_ptr<Tree> & getLast() {return *children.end();}
         std::shared_ptr<Tree> & getChild(int i) {return children[i];}
   };

   template <typename T>
   void dfsTestAll(std::shared_ptr<Tree<T>> tree, std::function<bool(std::shared_ptr<Tree<T>>)> & test, bool & result) {
      if (test(tree)) {result = result && true;}
      else {result = result && false;}
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsTestAnd(tree->getChild(i), test, result);}
   }

   template <typename T>
   void dfsTestAny(std::shared_ptr<Tree<T>> tree, std::function<bool(std::shared_ptr<Tree<T>>)> & test, bool & result) {
      if (test(tree)) {result = result && true;}
      else {result = result || false;}
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsTestAnd(tree->getChild(i), test, result);}
   }

   template <typename T>
   void dfsTestExit(std::shared_ptr<Tree<T>> tree, std::function<bool(std::shared_ptr<Tree<T>>)> & test, std::string msg) {
      if (test(tree)) {
         std::cerr << msg << std::endl;
         exit(1);
      }
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsTestExit(tree->getChild(i), test, msg);}
   }
   
   template <typename T>
   void dfsMap(std::shared_ptr<Tree<T>>  tree, std::function<void(T)> & fun) {
      fun(tree->getData());
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsApplyAll(tree->getChild(i), fun);}
   }

   template <typename T>
   void dfsMapT(std::shared_ptr<Tree<T>> tree, std::function<void(std::shared_ptr<Tree<T>>)> & fun) {
      fun(tree);
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsMapT(tree->getChild(i), fun);}
   }

   template <typename T, typename S>
   void dfsFold(std::shared_ptr<Tree<T>> tree, S & cont, std::function<void(T, S &)> & fun) {
      fun(tree->getData(), cont);
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsFold(tree->getChild(i), cont, fun);}
   }

   template <typename T, typename S>
   void dfsFoldT(std::shared_ptr<Tree<T>> tree, S & cont, std::function<void(std::shared_ptr<Tree<T>>, S &)> & fun) {
      fun(tree, cont);
      if (tree->isLeaf()) {return;}
      for (int i = 0; i < tree->getSize(); i++) {dfsFoldT(tree->getChild(i), cont, fun);}
   }

   template <typename T>
   void dfsPrinter(std::shared_ptr<Tree<T>> tree, std::ostream & os, std::function<void(std::shared_ptr<Tree<T>>, std::ostream &)> & fun) {
      if (tree->isLeaf()) {
         fun(tree, os);
         return;
      }
      fun(tree, os);
      for (int i = 0; i < tree->getSize(); i++) {dfsPrinter(tree->getChild(i), os, fun);}
   }
}

#endif
