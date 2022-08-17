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

   namespace Phobic {
      class Scanner;
      class Repl;
      class AST;
   }
}

// predeclare yylex
%code top {
   #include <iostream>
   #include "scanner.h"
   #include "parser.hpp"
   #include "ast.hpp"
   #include "repl.h"
   #include "location.hh"

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
%token <std::string> LBPAR "[";
%token <std::string> RBPAR "]";
%token <std::string> LCPAR "{";
%token <std::string> RCPAR "}";
%token <std::string> PERIOD ".";
%token <std::string> COMMA ",";
%token <std::string> COLON ":";
%token <std::string> BSLASH "\\";
%token <std::string> DEFMACRO "def-macro";
%token <std::string> WAIT "wait";
%token <std::string> IF "if";
%token <std::string> NEW "new";
%token <std::string> STOP "stop";
%token <std::string> PARALLEL "$";
%token <std::string> DISJOIN "@";
%token <std::string> REPLICATE "!";
%token <std::string> ADD "+";
%token <std::string> SUB "-";
%token <std::string> MUL "*";
%token <std::string> DIV "/";
%token <std::string> MOD "%";
%token <std::string> AND "&";
%token <std::string> OR "|";
%token <std::string> NOT "~";
%token <std::string> CONCAT "++";
%token <std::string> EQ "==";
%token <std::string> NEQ "!=";
%token <std::string> TRUE "True";
%token <std::string> FALSE "False";
%token <std::string> INT_T "Int";
%token <std::string> FLOAT_T "Float";
%token <std::string> BOOL_T "Bool";
%token <std::string> CHAR_T "Char";
%token <std::string> STRING_T "String";
%token <std::string> PROC_T "Proc";
%token <std::string> INT "Integer";
%token <std::string> FLOAT "Floating Point";
%token <std::string> VAR "Variable";
%token <std::string> CHAR "Character Literal";
%token <std::string> STRING "String Literal";
%token SEND "Send";
%token RECEIVE "Receive";
%token PDISJOIN "Probabilistic Disjunction";
%token VAPP "Variable Application";
%token MAPP "Macro Application";

%type<Phobic::AST *> terminal;
%type<Phobic::AST *> term;
%type<Phobic::AST *> btype;
%type<Phobic::AST *> type;
%type<Phobic::AST *> mdef;
%type<Phobic::AST *> vardef;
%type<Phobic::AST *> chandef;
%type<Phobic::AST *> cdef;
%type<Phobic::AST *> variableterm;
%type<Phobic::AST *> varterm;
%type<Phobic::AST *> vterm;
%type<Phobic::AST *> comp;
%type<Phobic::AST *> pcalc;
%type<Phobic::AST *> definitions;
%type<Phobic::AST *> prog;
%type<Phobic::AST *> program; 


%start program

%left ADD
%left SUB
%left MUL
%left DIV
%left MOD
%left AND
%left OR
%left NOT
%left CONCAT
%left PARALLEL
%left DISJOIN
%precedence NEG
%precedence REP
%precedence SIL
%precedence SND
%precedence RCV
%precedence FAP
%precedence PDJ
%precedence IFF
%precedence VBL
%precedence WAI
%precedence NEW

%%

program : prog {
   repl.m_data.setAST($1);
   $$ = $1;
}
| definitions {
   repl.m_data.setAST($1);
   $$ = $1;
}
;

prog : LBPAR DEFMACRO VAR mdef RBPAR LCPAR pcalc RCPAR prog {
   AST * temp = new AST(symbol_kind::S_DEFMACRO, $3);
   temp->concat($4);
   temp->concat($7);
   temp->concat($9);
   $$ = temp;
}
| pcalc {$$ = $1;}
;

definitions :  LBPAR DEFMACRO VAR mdef RBPAR LCPAR pcalc RCPAR definitions {
   AST * temp = new AST(symbol_kind::S_DEFMACRO, $3);
   temp->concat($4);
   temp->concat($7);
   temp->concat($9);
   $$ = temp;
}
|  LBPAR DEFMACRO VAR mdef RBPAR LCPAR pcalc RCPAR {
   AST * temp = new AST(symbol_kind::S_DEFMACRO, $3);
   temp->concat($4);
   temp->concat($7);
   $$ = temp;
}

pcalc : VAR LAPAR vterm RAPAR PERIOD pcalc %prec SND {
   AST * temp = new AST(symbol_kind::S_SEND, $1);
   temp->concat($3);
   temp->concat($6);
   $$ = temp;
}
| VAR LNPAR variableterm RNPAR PERIOD pcalc %prec RCV {
   AST * temp = new AST(symbol_kind::S_RECEIVE, $1);
   temp->concat($3);
   temp->concat($6);
   $$ = temp;
}
| WAIT LCPAR term RCPAR PERIOD pcalc %prec WAI {
   AST * temp = new AST(symbol_kind::S_WAIT, $1);
   temp->concat($3);
   temp->concat($6);
   $$ = temp;
}
| VAR PERIOD pcalc %prec VBL {
   AST * temp = new AST(symbol_kind::S_VAPP, $1);
   temp->concat($3);
   $$ = temp;
}
| LBPAR IF comp RBPAR LCPAR pcalc RCPAR PERIOD pcalc %prec IFF {
   AST * temp = new AST(symbol_kind::S_IF, $2);
   temp->concat($3);
   temp->concat($6);
   temp->concat($9);
   $$ = temp;
}
| LBPAR NEW cdef RBPAR LCPAR pcalc RCPAR {
   AST * temp = new AST(symbol_kind::S_NEW, $2);
   temp->concat($3);
   temp->concat($6);
   $$ = temp;
}
| LBPAR NEW cdef RBPAR LCPAR pcalc RCPAR PERIOD pcalc %prec NEW {
   AST * temp = new AST(symbol_kind::S_NEW, $2);
   temp->concat($3);
   temp->concat($6);
   temp->concat($9);
   $$ = temp;
}
| LBPAR VAR RBPAR LCPAR vterm RCPAR PERIOD pcalc %prec FAP {
   AST * temp = new AST(symbol_kind::S_MAPP, $2);
   temp->concat($5);
   temp->concat($8);
   $$ = temp;
}
| pcalc PARALLEL pcalc {
   AST * temp = new AST(symbol_kind::S_PARALLEL, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| pcalc DISJOIN pcalc {
   AST * temp = new AST(symbol_kind::S_PARALLEL, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| pcalc DISJOIN LCPAR term RCPAR pcalc %prec PDJ {
   AST * temp = new AST(symbol_kind::S_PDISJOIN, $2);
   temp->concat($1);
   temp->concat($4);
   temp->concat($6);
   $$ = temp;
}
| LNPAR pcalc RNPAR {$$ = $2;}
| REPLICATE pcalc %prec REP {
   AST * temp = new AST(symbol_kind::S_REPLICATE, $1);
   temp->concat($2);
   $$ = temp;
}
| VAR LAPAR vterm RAPAR {
   AST * temp = new AST(symbol_kind::S_SEND, $1);
   temp->concat($3);
   $$ = temp;
}
| VAR LNPAR variableterm RNPAR {
   AST * temp = new AST(symbol_kind::S_RECEIVE, $1);
   temp->concat($3);
   $$ = temp;
}
| WAIT LCPAR term RCPAR {
   AST * temp = new AST(symbol_kind::S_WAIT, $1);
   temp->concat($3);
   $$ = temp;
}
| STOP {
   AST * temp = new AST(symbol_kind::S_STOP, $1);
   $$ = temp;
}
;

vterm : varterm COMMA vterm {
   AST * temp = new AST(symbol_kind::S_COMMA, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| varterm {$$ = $1;}
| {$$ = nullptr;}
;

varterm : term {$$ = $1;}
| pcalc {$$ = $1;}
;

variableterm : VAR COMMA variableterm {
   AST * temp = new AST(symbol_kind::S_COMMA, $2);
   temp->addChild(symbol_kind::S_VAR, $1);
   temp->concat($3);
   $$ = temp;
}
| VAR {
   AST * temp = new AST(symbol_kind::S_COMMA, $1);
   $$ = temp;
}
;

comp : varterm EQ varterm {
   AST * temp = new AST(symbol_kind::S_EQ, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| varterm NEQ varterm {
   AST * temp = new AST(symbol_kind::S_NEQ, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
;

term : term ADD term {
   AST * temp = new AST(symbol_kind::S_ADD, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| term SUB term {
   AST * temp = new AST(symbol_kind::S_SUB, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| term MUL term {
   AST * temp = new AST(symbol_kind::S_MUL, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| term DIV term {
   AST * temp = new AST(symbol_kind::S_DIV, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| term MOD term {
   AST * temp = new AST(symbol_kind::S_MOD, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| term AND term {
   AST * temp = new AST(symbol_kind::S_AND, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| term OR term {
   AST * temp = new AST(symbol_kind::S_OR, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| LNPAR term RNPAR {$$ = $2;}
| NOT term %prec NEG {
   AST * temp = new AST(symbol_kind::S_NOT, $1);
   temp->concat($2);
   $$ = temp;
}
| term CONCAT term {
   AST * temp = new AST(-1*symbol_kind::S_ADD, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| terminal {$$ = $1;}
;

terminal : INT {
   AST * temp = new AST(symbol_kind::S_INT, $1);
   $$ = temp;
}
| FLOAT {
   AST * temp = new AST(symbol_kind::S_FLOAT, $1);
   $$ = temp;
}
| TRUE {
   AST * temp = new AST(symbol_kind::S_TRUE, $1);
   $$ = temp;
}
| FALSE {
   AST * temp = new AST(symbol_kind::S_FALSE, $1);
   $$ = temp;
}
| CHAR {
   AST * temp = new AST(symbol_kind::S_CHAR, $1);
   $$ = temp;
}
| STRING {
   AST * temp = new AST(symbol_kind::S_STRING, $1);
   $$ = temp;
}
| VAR {
   AST * temp = new AST(symbol_kind::S_VAR, $1);
   $$ = temp;
}
;

mdef : vardef COMMA mdef {
   AST * temp = new AST(symbol_kind::S_COMMA, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| chandef COMMA mdef {
   AST * temp = new AST(symbol_kind::S_COMMA, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| vardef {$$ = $1;}
| chandef {$$ = $1;}
| {$$ = nullptr;}
;


vardef : VAR COLON btype {
   AST * temp = new AST(symbol_kind::S_COLON, $2);
   temp->addChild(symbol_kind::S_VAR, $1);
   temp->concat($3);
   $$ = temp;
}

cdef : chandef COMMA cdef {
   AST * temp = new AST(symbol_kind::S_COMMA, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| chandef {$$ = $1;}
;

chandef : VAR COLON COLON type {
   AST * temp = new AST(-1 *symbol_kind::S_COLON, $2);
   temp->addChild(symbol_kind::S_VAR, $1);
   temp->concat($4);
   $$ = temp;
}

type : btype BSLASH type  {
   AST * temp = new AST(symbol_kind::S_BSLASH, $2);
   temp->concat($1);
   temp->concat($3);
   $$ = temp;
}
| btype {$$ = $1;}
;

btype : INT_T {
   AST * temp = new AST(symbol_kind::S_INT_T, $1);
   $$ = temp;
}
| FLOAT_T {
   AST * temp = new AST(symbol_kind::S_FLOAT_T, $1);
   $$ = temp;
}
| BOOL_T {
   AST * temp = new AST(symbol_kind::S_BOOL_T, $1);
   $$ = temp;
}
| CHAR_T {
   AST * temp = new AST(symbol_kind::S_CHAR_T, $1);
   $$ = temp;
}
| STRING_T {
   AST * temp = new AST(symbol_kind::S_STRING_T, $1);
   $$ = temp;
}
| PROC_T {
   AST * temp = new AST(symbol_kind::S_PROC_T, $1);
   $$ = temp;
}
;

%%

void Phobic::Parser::error(const location& loc, const std::string& m) {
   std::cerr << "Error at [" << repl.location() << "]: " << m << std::endl;
}
