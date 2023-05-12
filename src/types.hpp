#ifndef TYPES_HPP
#define TYPES_HPP

#include <string>
#include <vector>
#include "ast.hpp"
#include "predicate.hpp"

namespace Phobic {
   class PreType {
      private:
         std::string name;
         std::vector<AST> data;

      public:
         PreType(AST subtree) {

         }

         std::shared_ptr<Type> getType() {

         }
   };

   enum Kind {
      BASIC,
      CHANNEL,
      TYPEVAR,
      BEHAVIOR,
      REFINEMENT,
      CLASS,
      TEMPLATE
   };

   class Type {
      private:
         std::string name;
         int kind;

      public:
         virtual bool operator==(const Type &) const = 0;
   };

   class Basic : public Type {
      public:
         Basic(std::string str) {name = str; kind = BASIC;}
   };

   class ChannelType : public Type {
      public:
         ChannelType(std::string str, int val) {name = str; kind = val;}
   };

   class TypeVar : public Type {
      public:
         TypeVar(std::string) {name = str; kind = TYPEVAR;}
   };

   class Behavior : public Type {

   };

   class ClassType : public Type {

   };

   class TemplateType : public type {

   };

   template <class T>
   class Refinement : public Type {

   };
};

#endif
