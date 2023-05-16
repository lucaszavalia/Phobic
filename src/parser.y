%skeleton "lalr1.cc"
%require "3.0"

// initial definitions
%defines
%define api.parser.class { Parser }
%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { Phobic }

// include relevant files
%code requires {
   #include <iostream>
   #include <string>
   #include <vector>
   #include <memory>
   #include "ast.hpp"   

   namespace Phobic {
      class Scanner;
      class Repl;
   }
}

// predeclare yylex
%code top {
   #include <iostream>
   #include "parser.hpp"
   #include "repl.h"
   #include "scanner.h"
   #include "location.hh"

   extern int yylineno;

   static Phobic::Parser::symbol_type yylex(Phobic::Scanner& scanner, Phobic::Repl& repl) {
      return scanner.get_next_token();
   }
}

%lex-param { Phobic::Scanner& scanner }
%lex-param { Phobic::Repl& repl }
%parse-param { Phobic::Scanner& scanner }
%parse-param { Phobic::Repl& repl }

%locations
%define parse.trace
%define parse.error verbose
%define api.token.prefix {TOKEN_}

%token END 0 "end of file"
%token <std::string> LAPAR "<";
%token <std::string> RAPAR ">";
%token <std::string> LNPAR "(";
%token <std::string> RNPAR ")";
%token <std::string> LCPAR "{";
%token <std::string> RCPAR "}";
%token <std::string> LBPAR "[";
%token <std::string> RBPAR "]";
%token <std::string> PERIOD "."
%token <std::string> COMMA ",";
%token <std::string> COLON ":";
%token <std::string> OBJACC "::";
%token <std::string> REFINE "refine";
%token <std::string> WITH "with";
%token <std::string> WHERE "where";
%token <std::string> PROVES ":-";
%token <std::string> BSLASH "\\";
%token <std::string> IMPORT "import";
%token <std::string> TYPE "type";
%token <std::string> REFINEMENT "refinement";
%token <std::string> CLASS "class";
%token <std::string> SELF "self";
%token <std::string> CONSTRUCTOR "constructor";
%token <std::string> PUBLIC "public";
%token <std::string> PRIVATE "private";
%token <std::string> PROTECTED "protected";
%token <std::string> AGENT "agent"
%token <std::string> IF "if";
%token <std::string> ELIF "elif";
%token <std::string> ELSE "else";
%token <std::string> SWITCH "switch";
%token <std::string> CASE "case";
%token <std::string> DEFAULT "default";
%token <std::string> NEW "new";
%token <std::string> STOP "stop";
%token <std::string> ASSERT "assert";
%token <std::string> UNSAFE "unsafe";
%token <std::string> PARALLEL "|";
%token <std::string> DISJOIN "@";
%token <std::string> ADD "+";
%token <std::string> SUB "-";
%token <std::string> MUL "*";
%token <std::string> DIV "/";
%token <std::string> MOD "%";
%token <std::string> AND "and";
%token <std::string> OR "or";
%token <std::string> XOR "xor";
%token <std::string> NOT "not";
%token <std::string> IMPL "impl";
%token <std::string> GET "get";
%token <std::string> CARET "^";
%token <std::string> TILDE "~";
%token <std::string> CONCAT "++";
%token <std::string> SUBSTR "//";
%token <std::string> EQ "==";
%token <std::string> NEQ "!=";
%token <std::string> GEQ ">=";
%token <std::string> LEQ "<=";
%token <std::string> STORE "<<";
%token <std::string> TRUE "True";
%token <std::string> FALSE "False";
%token <std::string> INT_T "Int";
%token <std::string> FLOAT_T "Float";
%token <std::string> BOOL_T "Bool";
%token <std::string> CHAR_T "Char";
%token <std::string> STRING_T "String";
%token <std::string> LEX_T "Lex";
%token <std::string> PROC_T "Proc";
%token <std::string> OBJ_T "Object";
%token <std::string> FORALL "forall";
%token <std::string> EXISTS "exists";
%token <std::string> INT "Integer";
%token <std::string> FLOAT "Floating Point";
%token <std::string> VAR "Variable";
%token <std::string> CHAR "Character Literal";
%token <std::string> STRING "String Literal";
%token <std::string> IO "IO";
%token <std::string> FILE "FILE";
%token <std::string> RAND "RAND";
%token <std::string> MPI "MPI";
%token <std::string> GPU "GPU";
%token <std::string> SERIALIZE "SERIALIZE";
%token <std::string> DESERIALIZE "DESERIALIZE";
%token <std::string> ENCRYPT "ENCRYPT";
%token <std::string> DECRYPT "DECRYPT";
%token <std::string> TCP "TCP";
%token <std::string> UDP "UDP";
%token <std::string> IP "IP";
%token <std::string> HTTP "HTTP";
%token <std::string> SOCKET "SOCKET";
%token <std::string> ARROW "->";
%token <std::string> INP "?";
%token <std::string> OUT "!";
%token <std::string> HASHTAG "#";
%token <std::string> DOLLAR "$";
%token PHOBIC "Phobic";
%token SEND "Send";
%token RECEIVE "Receive";
%token PDISJOIN "Probabilistic Disjunction";
%token VAPP "Variable Application";
%token OBJECT "Obj";
%token MAPP "Macro Application";
%token LIST "[]";
%type <Phobic::AST> phobic;
%type <Phobic::AST> importstar;
%type <Phobic::AST> defn;
%type <Phobic::AST> prog;
%type <Phobic::AST> defctm;
%type <Phobic::AST> typedef;
%type <Phobic::AST> agentdef;
%type <Phobic::AST> classdef;
%type <Phobic::AST> classbody;
%type <Phobic::AST> conslist;
%type <Phobic::AST> constructor;
%type <Phobic::AST> classmember;
%type <Phobic::AST> access;
%type <Phobic::AST> inheritance;
%type <Phobic::AST> agent;
%type <Phobic::AST> sum;
%type <Phobic::AST> prefix;
%type <Phobic::AST> agentlist;
%type <Phobic::AST> objaccess;
%type <Phobic::AST> objcall;
%type <Phobic::AST> tdef;
%type <Phobic::AST> typelist;
%type <Phobic::AST> chandef;
%type <Phobic::AST> maybechandef;
%type <Phobic::AST> chan;
%type <Phobic::AST> varlist;
%type <Phobic::AST> caseterm;
%type <Phobic::AST> elseterm;
%type <Phobic::AST> elifterm;
%type <Phobic::AST> comp;
%type <Phobic::AST> term;
%type <Phobic::AST> type;
%type <Phobic::AST> rtype;
%type <Phobic::AST> btype;
%type <Phobic::AST> refinement;
%type <Phobic::AST> pseudotype;
%type <Phobic::AST> pseudotypelist;
%type <Phobic::AST> pseudotdef;
%type <Phobic::AST> rtypelist;
%type <Phobic::AST> fml;
%type <Phobic::AST> fcomp;
%type <Phobic::AST> fterm;
%start phobic;

%left PERIOD
%left PARALLEL
%left DISJOIN
%left ADD
%left SUB
%left MUL
%left DIV
%left MOD
%left AND
%left OR
%left XOR
%left CONCAT
%left SUBSTR
%left STORE
%left ARROW
%left BSLASH
%left IMPL
%left CARET
%left TILDE
%precedence UNARY
%precedence BINARY

//remember 
//left associativity is for binary operations
//precedence is for unary operations

%%

//top level, either header or program
phobic : importstar defn {
   Phobic::AST tree = mkAST(symbol_kind::S_PHOBIC, UNTYPEABLE, "PHOBIC");
   printAST(tree);
   if ($1 != nullptr) {
      tree->concat($1);
      tree->concat($2);
   }
   else {
      tree->concat($2);
   }
   repl.m_data.setAST(tree);
   $$ = tree;
}
| importstar prog {
   Phobic::AST tree = mkAST(symbol_kind::S_PHOBIC, UNTYPEABLE, "PHOBIC");
   if ($1 != nullptr) {
      tree->concat($1);
      tree->concat($2);
   }
   else {
      tree->concat($2);
   }
   repl.m_data.setAST(tree);
   $$ = tree;
}
;

importstar : IMPORT STRING importstar {
   Phobic::AST tree = mkAST(symbol_kind::S_IMPORT, UNTYPEABLE, $1);
   Phobic::AST temp = mkAST(symbol_kind::S_STRING, LEX, $1);
   tree->concat(temp);
   tree->concat($3);
   $$ = tree;
}
| %empty {$$ = nullptr;}
;

defn : defctm defn {
   Phobic::AST tree = $1;
   tree->concat($2);
   $$ = tree;
}
| defctm {$$ = $1;}
;

prog : defctm prog {
   Phobic::AST tree = $1;
   tree->concat($2);
   $$ = tree;
}
| agent {$$ = $1;}
;

//construct definitions (consider adding theory definition here)
defctm : classdef {$$ = $1;}
| typedef {$$ = $1;}
| agentdef {$$ = $1;}
;

classdef : LNPAR CLASS VAR inheritance RNPAR LCPAR classbody RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_CLASS, UNTYPEABLE, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, UNTYPEABLE, $3);
   tree->concat(temp);
   if ($4 != nullptr) {tree->concat($4);}
   tree->concat($7);
   $$ = tree;
}
;

typedef : LNPAR TYPE VAR RNPAR LCPAR type RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_TYPE, UNTYPEABLE, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, UNTYPEABLE, $3);
   tree->concat(temp);
   tree->concat($6);
   $$ = tree;
}
| LNPAR TYPE VAR RNPAR LCPAR refinement RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_TYPE, UNTYPEABLE, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, UNTYPEABLE, $3);
   tree->concat(temp);
   tree->concat($6);
   $$ = tree;
}
;

agentdef : LNPAR AGENT VAR maybechandef RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_AGENT, UNTYPEABLE, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, UNTYPEABLE, $3);
   tree->concat(temp);
   if ($4 != nullptr) {tree->concat($4);}
   tree->concat($7);
   $$ = tree;
}
;

//pi calculus productions
agent : agent PARALLEL agent %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_PARALLEL, PROC, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| LNPAR NEW chandef RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_NEW, PROC, $2);
   tree->concat($3);
   tree->concat($6);
   $$ = tree;
}
| LNPAR ASSERT chandef RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_ASSERT, PROC, $2);
   tree->concat($3);
   tree->concat($6);
   $$ = tree;
}
| LNPAR UNSAFE RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_UNSAFE, PROC, $2);
   tree->concat($5);
   $$ = tree;
}
| objaccess LCPAR agentlist RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_OBJECT, OBJ, "OBJECT");
   tree->concat($1);
   tree->concat($3);
   $$ = tree; 
}
| term {$$ = $1;}
| sum {$$ = $1;}
;

sum : sum DISJOIN sum %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DISJOIN, PROC, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| sum DISJOIN LCPAR term RCPAR sum %prec BINARY{
   Phobic::AST tree = mkAST(symbol_kind::S_DISJOIN, PROC, $2);
   tree->concat($1);
   tree->concat($4);
   tree->concat($6);
   $$ = tree;
}
| LNPAR IF comp RNPAR LCPAR sum RCPAR elseterm {
   Phobic::AST tree = mkAST(symbol_kind::S_IF, PROC, $2);
   tree->concat($3);
   tree->concat($6);
   if ($8 != nullptr) {tree->concat($8);}
}
| LNPAR SWITCH VAR RNPAR LCPAR caseterm DEFAULT LCPAR sum RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_SWITCH, PROC, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, PROC, $3);
   tree->concat(temp);
   if ($6 != nullptr) {tree->concat($6);}
   Phobic::AST subtree = mkAST(symbol_kind::S_DEFAULT, PROC, $7);
   subtree->concat($9);
   tree->concat(subtree);
   $$ = tree;
}
| prefix {$$ = $1;}
;

prefix : prefix PERIOD prefix {
   Phobic::AST tree = mkAST(symbol_kind::S_PERIOD, PROC, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| chan INP LNPAR varlist RNPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_INP, PROC, $2 + $1->getData().getRaw());
   tree->concat($4);
   $$ = tree;
}
| chan OUT LAPAR agentlist RAPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_OUT, PROC, $2 + $1->getData().getRaw());
   if ($4 == nullptr) {std::cout << "agent list is null\n";}
   tree->concat($4);
   $$ = tree;
}
| objaccess objcall {
   Phobic::AST tree = mkAST(symbol_kind::S_OBJECT, OBJ, "OBJECT");
   tree->concat($1);
   tree->concat($2);
   $$ = tree;
}
| VAR LCPAR agentlist RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, PROC, $1);
   tree->concat($3);
   $$ = tree;
}
| STOP {
   Phobic::AST tree = mkAST(symbol_kind::S_STOP, PROC, $1);
   $$ = tree;
}
;

//classdef auxiliary productions
inheritance : PROVES varlist {
   Phobic::AST tree = mkAST(symbol_kind::S_PROVES, UNTYPEABLE, $1);
   tree->concat($2);
   $$ = tree;
}
| %empty {$$ = nullptr;}
;

access : PRIVATE {
   Phobic::AST tree = mkAST(symbol_kind::S_PRIVATE, UNTYPEABLE, $1);
   $$ = tree;
}
| PUBLIC {
   Phobic::AST tree = mkAST(symbol_kind::S_PUBLIC, UNTYPEABLE, $1);
   $$ = tree;
}
| PROTECTED {
   Phobic::AST tree = mkAST(symbol_kind::S_PROTECTED, UNTYPEABLE, $1);
   $$ = tree;
}
;

classbody : conslist classmember {
   Phobic::AST tree = nullptr;
   if ($1 != nullptr) {tree = $1;}
   if ($2 != nullptr) {
      if (tree == nullptr) {tree = $2;}
      else {tree->concat($2);}
   }
   $$ = tree;
}
;

conslist : constructor conslist {
   Phobic::AST tree = mkAST(symbol_kind::S_CONSTRUCTOR, PROC, "constructor");
   tree->concat($1);
   if ($2 != nullptr) {tree->concat($2);}
   $$ = tree;
}
| %empty {$$ = nullptr;}
;


constructor : LNPAR CONSTRUCTOR maybechandef RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_CONSTRUCTOR, PROC, $2);
   if ($3 != nullptr) {tree->concat($3);}
   tree->concat($6);
   $$ = tree;
}
;

classmember : access agentdef classmember {
   Phobic::AST tree = $1;
   tree->concat($2);
   tree->concat($3);
   $$ = tree;
}
| access classdef classmember {
   Phobic::AST tree = $1;
   tree->concat($2);
   tree->concat($3);
   $$ = tree;
}
| access typedef classmember {
   Phobic::AST tree = $1;
   tree->concat($2);
   tree->concat($3);
   $$ = tree;
}
| access VAR COLON type classmember {
   Phobic::AST tree = $1;
   Phobic::AST subtree = mkAST(symbol_kind::S_COLON, OBJ, $3);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, OBJ, $2);
   subtree->concat(temp);
   subtree->concat($4);
   tree->concat(subtree);
   tree->concat($5);
   $$ = tree;
}
| access agentdef {
   Phobic::AST tree = $1;
   tree->concat($2);
   $$ = tree;
}
| access classdef {
   Phobic::AST tree = $1;
   tree->concat($2);
   $$ = tree;
}
| access typedef {
   Phobic::AST tree = $1;
   tree->concat($2);
   $$ = tree;
}
| access VAR COLON type {
   Phobic::AST tree = $1;
   Phobic::AST subtree = mkAST(symbol_kind::S_COLON, OBJ, $3);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, OBJ, $2);
   subtree->concat(temp);
   subtree->concat($4);
   tree->concat(subtree);
   $$ = tree;
}
;

//typedef auxiliary productions
type : LAPAR typelist RAPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_BSLASH, TYPE, "()");
   tree->concat($2);
   $$ = tree;
}
| type ARROW type %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_ARROW, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| HASHTAG tdef %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_HASHTAG, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| DOLLAR tdef %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DOLLAR, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| HASHTAG type %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_HASHTAG, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| DOLLAR type %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DOLLAR, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| TILDE type %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_TILDE, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| LBPAR type PARALLEL INT RBPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_LIST, TYPE , "[]");
   Phobic::AST size = mkAST(symbol_kind::S_INT, TYPE, $4);
   tree->concat($2);
   tree->concat(size);
   $$ = tree;
}
| VAR LCPAR typelist RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, TYPE, $1);
   tree->concat($3);
   $$ = tree;
}
| LNPAR type RNPAR {$$ = $2;}
| btype {$$ = $1;}
;

btype : INT_T {
   Phobic::AST tree = mkAST(symbol_kind::S_INT_T, TYPE, $1);
   $$ = tree;
}
| BOOL_T {
   Phobic::AST tree = mkAST(symbol_kind::S_BOOL_T, TYPE, $1);
   $$ = tree;
}
| FLOAT_T {
   Phobic::AST tree = mkAST(symbol_kind::S_FLOAT_T, TYPE, $1);
   $$ = tree;
}
| LEX_T {
   Phobic::AST tree = mkAST(symbol_kind::S_LEX_T, TYPE, $1);
   $$ = tree;
}
| PROC_T {
   Phobic::AST tree = mkAST(symbol_kind::S_PROC_T, TYPE, $1);
   $$ = tree;
}
| OBJ_T {
   Phobic::AST tree = mkAST(symbol_kind::S_OBJ_T, TYPE, $1);
   $$ = tree;
}
| VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, TYPE, $1);
   $$ = tree;
}
;

refinement : REFINE pseudotype WITH fml {
   Phobic::AST tree = mkAST(symbol_kind::S_REFINE, TYPE, $1);
   tree->concat($2);
   Phobic::AST subtre = mkAST(symbol_kind::S_WITH, TYPE, $3);
   tree->concat($4);
   $$ = tree;
}
;

typelist : type COMMA typelist {
   Phobic::AST tree = mkAST(symbol_kind::S_COMMA, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| type {$$ = $1;}

pseudotype : LAPAR pseudotypelist RAPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_BSLASH, TYPE, "()");
   tree->concat($2);
   $$ = tree;
}
| pseudotype ARROW pseudotype %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_ARROW, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| HASHTAG pseudotdef %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_HASHTAG, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| DOLLAR pseudotdef %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DOLLAR, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| HASHTAG pseudotype %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_HASHTAG, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| DOLLAR pseudotype %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DOLLAR, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| TILDE pseudotype %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_TILDE, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| LBPAR pseudotype PARALLEL INT RBPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_LIST, TYPE , "[]");
   Phobic::AST size = mkAST(symbol_kind::S_INT, TYPE, $4);
   tree->concat($2);
   tree->concat(size);
   $$ = tree;
}
| VAR LCPAR pseudotypelist RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, TYPE, $1);
   tree->concat($3);
   $$ = tree;
}
| LNPAR pseudotype RNPAR {$$ = $2;}
| VAR COLON rtype {
   Phobic::AST tree = mkAST(symbol_kind::S_COLON, TYPE, $2);
   Phobic::AST subtree = mkAST(symbol_kind::S_VAR, TYPE, $1);
   tree->concat(subtree);
   tree->concat($3);
   $$ = tree;
}
| rtype {$$ = $1;}
;

rtype :  INT_T {
   Phobic::AST tree = mkAST(symbol_kind::S_INT_T, TYPE, $1);
   $$ = tree;
}
| BOOL_T {
   Phobic::AST tree = mkAST(symbol_kind::S_BOOL_T, TYPE, $1);
   $$ = tree;
}
| FLOAT_T {
   Phobic::AST tree = mkAST(symbol_kind::S_FLOAT_T, TYPE, $1);
   $$ = tree;
}
| VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, TYPE, $1);
   $$ = tree;
}
;

pseudotypelist : pseudotype COMMA pseudotypelist {
   Phobic::AST tree = mkAST(symbol_kind::S_COMMA, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| pseudotype {$$ = $1;}
;

pseudotdef : IO LCPAR pseudotype RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_IO, TYPE, $1);
   tree->concat($3);
   $$ = tree;
}
| FILE LCPAR pseudotype COMMA STRING COMMA STRING RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_FILE, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp1 = mkAST(symbol_kind::S_STRING, LEX, $5);
   tree->concat(temp1);
   Phobic::AST temp2 = mkAST(symbol_kind::S_STRING, LEX, $7);
   tree->concat(temp2);
   $$ = tree;
}
| RAND LCPAR pseudotype COMMA INT RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_RAND, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp = mkAST(symbol_kind::S_INT, INT, $5);
   tree->concat(temp);
   $$ = tree;
}
| ENCRYPT LCPAR pseudotype COMMA STRING RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_ENCRYPT, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp = mkAST(symbol_kind::S_STRING, LEX, $5);
   tree->concat(temp);
   $$ = tree;
}
| DECRYPT LCPAR pseudotype COMMA STRING RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_DECRYPT, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp = mkAST(symbol_kind::S_STRING, LEX, $5);
   tree->concat(temp);
   $$ = tree;
}
| SOCKET LCPAR pseudotype RCPAR { //unfinished
   Phobic::AST tree = mkAST(symbol_kind::S_SOCKET, TYPE, $1);
   tree->concat($3);
   $$ = tree;
}
;


rtypelist : VAR COLON rtype COMMA rtypelist {
   Phobic::AST tree = mkAST(symbol_kind::S_COMMA, TYPE, $4);
   Phobic::AST subtree0 = mkAST(symbol_kind::S_COLON, TYPE, $2);
   Phobic::AST subtree1 = mkAST(symbol_kind::S_VAR, TYPE, $1);
   subtree0->concat(subtree1);
   subtree0->concat($3);
   tree->concat(subtree0);
   tree->concat($5);
   $$ = tree;
}
| VAR COLON rtype {
   Phobic::AST tree = mkAST(symbol_kind::S_COLON, TYPE, $2);
   Phobic::AST subtree = mkAST(symbol_kind::S_COLON, TYPE, $1);
   tree->concat(subtree);
   tree->concat($3);
   $$ = tree;
}
;

fml : LNPAR EXISTS rtypelist RNPAR LCPAR fml RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_EXISTS, TYPE, $2);
   tree->concat($3);
   tree->concat($6);
   $$ = tree;
}
| LNPAR FORALL rtypelist RNPAR LCPAR fml RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_FORALL, TYPE, $2);
   tree->concat($3);
   tree->concat($6);
   $$ = tree;
}
| fml AND fml %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_AND, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fml OR fml %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_OR, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fml IMPL fml %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_IMPL, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| NOT fml %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_NOT, TYPE, $1);
   tree->concat($2);
   $$ = tree;
}
| TRUE {
   Phobic::AST tree = mkAST(symbol_kind::S_TRUE, TYPE, $1);
   $$ = tree;
}
| FALSE {
   Phobic::AST tree = mkAST(symbol_kind::S_FALSE, TYPE, $1);
   $$ = tree;
}
| fcomp {$$ = $1;}
;

fcomp : fterm EQ fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_EQ, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm NEQ fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_NEQ, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm LAPAR fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_LAPAR, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm RAPAR fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_RAPAR, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm LEQ fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_LEQ, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm GEQ fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_GEQ, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
;

fterm : fterm ADD fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_ADD, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm SUB fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_SUB, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm MUL fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_MUL, TYPE, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm DIV fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DIV, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| fterm MOD fterm %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_MOD, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| SUB fterm %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_SUB, NUM, $1);
   tree->concat($2);
}
| LNPAR fterm RNPAR {$$ = $2;}
| INT {
   Phobic::AST tree = mkAST(symbol_kind::S_INT, NUM, $1);
   $$ = tree;
}
| FLOAT {
   Phobic::AST tree = mkAST(symbol_kind::S_FLOAT, NUM, $1);
   $$ = tree;
}
| VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, NUM, $1);
   $$ = tree;
}
;

//agentdef auxiliary productions

maybechandef : chandef {$$ = $1;}
| %empty {$$ = nullptr;}
;

//pi calculus auxiliaries


tdef : IO LCPAR type RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_IO, TYPE, $1);
   tree->concat($3);
   $$ = tree;
}
| FILE LCPAR type COMMA STRING COMMA STRING RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_FILE, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp1 = mkAST(symbol_kind::S_STRING, LEX, $5);
   tree->concat(temp1);
   Phobic::AST temp2 = mkAST(symbol_kind::S_STRING, LEX, $7);
   tree->concat(temp2);
   $$ = tree;
}
| RAND LCPAR type COMMA INT RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_RAND, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp = mkAST(symbol_kind::S_INT, INT, $5);
   tree->concat(temp);
   $$ = tree;
}
| ENCRYPT LCPAR type COMMA STRING RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_ENCRYPT, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp = mkAST(symbol_kind::S_STRING, LEX, $5);
   tree->concat(temp);
   $$ = tree;
}
| DECRYPT LCPAR type COMMA STRING RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_DECRYPT, TYPE, $1);
   tree->concat($3);
   Phobic::AST temp = mkAST(symbol_kind::S_STRING, LEX, $5);
   tree->concat(temp);
   $$ = tree;
}
| SOCKET LCPAR type RCPAR { //unfinished
   Phobic::AST tree = mkAST(symbol_kind::S_SOCKET, TYPE, $1);
   tree->concat($3);
   $$ = tree;
}
;

chandef : VAR COLON type COMMA chandef {
   Phobic::AST tree = mkAST(symbol_kind::S_COMMA, PROC, $4);
   Phobic::AST subtree = mkAST(symbol_kind::S_COLON, PROC, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, DEFERRED, $1);
   subtree->concat(temp);
   subtree->concat($3);
   tree->concat(subtree);
   tree->concat($5);
   $$ = tree; 
}
| VAR COLON type {
   Phobic::AST tree = mkAST(symbol_kind::S_COLON, PROC, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, DEFERRED, $1);
   tree->concat(temp);
   tree->concat($3);
   $$ = tree;
}
;

chan : VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, PROC, $1);
   $$ = tree;
}
;

elseterm : elifterm ELSE LCPAR agent RCPAR {
   Phobic::AST subtree = mkAST(symbol_kind::S_ELSE, PROC, $2);
   subtree->concat($4);
   Phobic::AST tree = nullptr;
   if ($1 != nullptr) {
      tree = $1;
      tree->concat(subtree);
   }
   else {tree = subtree;}
   $$ = tree;
}
| %empty{$$ = nullptr;}
;

elifterm : LNPAR ELIF comp RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_ELIF, PROC, $2);
   tree->concat($3);
   tree->concat($6);
   $$ = tree;
}
| %empty {$$ = nullptr;}

caseterm : LNPAR CASE term RNPAR LCPAR agent RCPAR caseterm {
   Phobic::AST tree = mkAST(symbol_kind::S_CASE, PROC, $2);
   tree->concat($3);
   tree->concat($6);
   tree->concat($8);
   $$ = tree;
}
| LNPAR CASE term RNPAR LCPAR agent RCPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_CASE, PROC, $2);
   tree->concat($3);
   tree->concat($6);
   $$ = tree;
}
;

objaccess : VAR OBJACC objaccess {
   Phobic::AST tree = mkAST(symbol_kind::S_PERIOD, OBJ, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, OBJ, $1);
   tree->concat(temp);
   tree->concat($3);
   $$ = tree;
}
| SELF OBJACC objaccess {
   Phobic::AST tree = mkAST(symbol_kind::S_PERIOD, OBJ, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_SELF, OBJ, $1);
   tree->concat(temp);
   tree->concat($3);
   $$ = tree;
}
| VAR OBJACC VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_PERIOD, OBJ, $2);
   Phobic::AST temp0 = mkAST(symbol_kind::S_VAR, OBJ, $1);
   Phobic::AST temp1 = mkAST(symbol_kind::S_VAR, OBJ, $3);
   tree->concat(temp0);
   tree->concat(temp1);
   $$ = tree;
}
| SELF OBJACC VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_PERIOD, OBJ, $2);
   Phobic::AST temp0 = mkAST(symbol_kind::S_SELF, OBJ, $1);
   Phobic::AST temp1 = mkAST(symbol_kind::S_VAR, OBJ, $3);
   tree->concat(temp0);
   tree->concat(temp1);
   $$ = tree;
}
;

objcall : INP LNPAR varlist RNPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_INP, PROC, $2 + $1);
   tree->concat($3);
   $$ = tree;
}
| OUT LAPAR agentlist RAPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_OUT, PROC, $2 + $1);
   tree->concat($3);
   $$ = tree;
}
;

agentlist : agent COMMA agentlist {
   Phobic::AST tree = mkAST(symbol_kind::S_COMMA, DEFERRED, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| agent {$$ = $1;}
;

varlist : VAR COMMA varlist {
   Phobic::AST tree = mkAST(symbol_kind::S_COMMA, DEFERRED, $2);
   Phobic::AST temp = mkAST(symbol_kind::S_VAR, DEFERRED, $1);
   tree->concat(temp);
   tree->concat($3);
   $$ = tree;
}
| VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, DEFERRED, $1);
   $$ = tree;
}
;

comp : agent EQ agent %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_EQ, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| agent NEQ agent %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_NEQ, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term LAPAR term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_LAPAR, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term RAPAR term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_RAPAR, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term LEQ term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_LEQ, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term GEQ term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_GEQ, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
;

term : term ADD term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_ADD, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term SUB term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_SUB, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term MUL term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_MUL, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term DIV term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_DIV, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term MOD term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_MOD, NUM, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term AND term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_AND, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term OR term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_OR, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term XOR term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_XOR, BOOL, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term CONCAT term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_CONCAT, LEX, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term SUBSTR term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_SUBSTR, LEX, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| term STORE term %prec BINARY {
   Phobic::AST tree = mkAST(symbol_kind::S_STORE, LIST, $2);
   tree->concat($1);
   tree->concat($3);
   $$ = tree;
}
| SUB term %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_SUB, NUM, $1);
   tree->concat($2);
   $$ = tree;
}
| NOT term %prec UNARY {
   Phobic::AST tree = mkAST(symbol_kind::S_NOT, BOOL, $1);
   tree->concat($2);
   $$ = tree;
}
| VAR LBPAR fml RBPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_LIST, DEFERRED, "[]");
   Phobic::AST var = mkAST(symbol_kind::S_VAR, DEFERRED, $1);
   tree->concat(var);
   tree->concat($3);
   $$ = tree;
}
| LBPAR term WHERE fml RBPAR {
   Phobic::AST tree = mkAST(symbol_kind::S_LIST, DEFERRED, "[]");
   Phobic::AST where = mkAST(symbol_kind::S_WHERE, DEFERRED, $3);
   where->concat($4);
   tree->concat($2);
   tree->concat(where);
   $$ = tree;
}
| LNPAR term RNPAR {$$ = $2;}
| INT {
   Phobic::AST tree = mkAST(symbol_kind::S_INT, INT, $1);
   $$ = tree;
}
| TRUE {
   Phobic::AST tree = mkAST(symbol_kind::S_TRUE, BOOL, $1);
   $$ = tree;
}
| FALSE {
   Phobic::AST tree = mkAST(symbol_kind::S_FALSE, BOOL, $1);
   $$ = tree;
}
| FLOAT {
   Phobic::AST tree = mkAST(symbol_kind::S_FLOAT, FLOAT, $1);
   $$ = tree;
}
| CHAR {
   Phobic::AST tree = mkAST(symbol_kind::S_CHAR, CHAR, $1);
   $$ = tree;
}
| STRING {
   Phobic::AST tree = mkAST(symbol_kind::S_STRING, STRING, $1);
   $$ = tree;
}
| VAR {
   Phobic::AST tree = mkAST(symbol_kind::S_VAR, DEFERRED, $1);
   $$ = tree;
}
;

//

%%

void Phobic::Parser::error(const location& loc, const std::string& m) { 
   std::cerr << "Error in line " << scanner.get_yylineno() << " at token " << repl.location() << ": " << m << std::endl;
}
