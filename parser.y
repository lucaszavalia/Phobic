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
   }
}

// predeclare yylex
%code top {
   #include <iostream>
   #include "scanner.h"
   #include "parser.hpp"
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

%type<std::string> terminal;
%type<std::string> term;
%type<std::string> btype;
%type<std::string> type;
%type<std::string> vardef;
%type<std::string> vdef;
%type<std::string> variableterm;
%type<std::string> varterm;
%type<std::string> vterm;
%type<std::string> comp;
%type<std::string> pcalc;
%type<std::string> definitions;
%type<std::string> prog;
%type<std::string> program; 


%start program

%left ADD
%left SUB
%left MUL
%left DIV
%left MOD
%left AND
%left OR
%left NOT
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

%%

program : prog {std::cout << $1 << "\n";}
| definitions {std::cout << $1 << "\n";}
;

prog : LBPAR DEFMACRO VAR vdef RBPAR LCPAR pcalc RCPAR prog {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   $$ += $7;
   $$ += $8;
   $$ += $9;
   std::cout << $$ << "\n";
}
| pcalc {
   $$ += $1;
   std::cout << $$ << "\n";
}
;

definitions :  LBPAR DEFMACRO VAR vdef RBPAR LCPAR pcalc RCPAR definitions {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   $$ += $7;
   $$ += $8;
   $$ += $9;
   std::cout << $$ << "\n";
}
|  LBPAR DEFMACRO VAR vdef RBPAR LCPAR pcalc RCPAR {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   $$ += $7;
   $$ += $8;
   std::cout << $$ << "\n";
}

pcalc : VAR LAPAR vterm RAPAR PERIOD pcalc %prec SND {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   std::cout << $$ << "\n";
}
| VAR LNPAR variableterm RNPAR PERIOD pcalc %prec RCV {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   std::cout << $$ << "\n";
}
| WAIT LCPAR term RCPAR PERIOD pcalc %prec WAI {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   std::cout << $$ << "\n";
}
| VAR PERIOD pcalc %prec VBL {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| LBPAR IF comp RBPAR LCPAR pcalc RCPAR PERIOD pcalc %prec IFF {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   $$ += $7;
   $$ += $8;
   $$ += $9;
   std::cout << $$ << "\n";
}
| LBPAR NEW vdef RBPAR LCPAR pcalc RCPAR {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   $$ += $7;
   std::cout << $$ << "\n";
}
| LBPAR VAR RBPAR LCPAR vterm RCPAR PERIOD pcalc %prec FAP {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   $$ += $7;
   $$ += $8;
   std::cout << $$ << "\n";
}
| pcalc PARALLEL pcalc {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| pcalc DISJOIN pcalc {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| pcalc DISJOIN LCPAR term RCPAR pcalc %prec PDJ {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   $$ += $4;
   $$ += $5;
   $$ += $6;
   std::cout << $$ << "\n";
}
| LNPAR pcalc RNPAR {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| REPLICATE pcalc %prec REP {
   $$ += $1;
   $$ += $2;
   std::cout << $$ << "\n";
}
| STOP {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

vterm : varterm COMMA vterm {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| varterm {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

varterm : term {
   $$ = $1;
   std::cout << $$ << "\n";
}
| pcalc {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

variableterm : VAR COMMA variableterm {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";  
}
| VAR {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

comp : varterm EQ varterm {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| varterm NEQ varterm {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
;

term : term ADD term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| term SUB term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| term MUL term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| term DIV term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| term MOD term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| term AND term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| term OR term {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| LNPAR term RNPAR {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| NOT term %prec NEG {
   $$ += $1;
   $$ += $2;
   std::cout << $$ << "\n";
}
| terminal {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

terminal : INT {
   $$ = $1;
   std::cout << $$ << "\n";
}
| FLOAT {
   $$ = $1;
   std::cout << $$ << "\n";
}
| TRUE {
   $$ = $1;
   std::cout << $$ << "\n";
}
| FALSE {
   $$ = $1;
   std::cout << $$ << "\n";
}
| CHAR {
   $$ = $1;
   std::cout << $$ << "\n";
}
| STRING {
   $$ = $1;
   std::cout << $$ << "\n";
}
| VAR {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

vdef : vardef COMMA vdef {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| vardef {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

vardef : VAR COLON type {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
;

type : btype BSLASH type  {
   $$ += $1;
   $$ += $2;
   $$ += $3;
   std::cout << $$ << "\n";
}
| btype {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

btype : INT_T {
   $$ = $1;
   std::cout << $$ << "\n";
}
| FLOAT_T {
   $$ = $1;
   std::cout << $$ << "\n";
}
| BOOL_T {
   $$ = $1;
   std::cout << $$ << "\n";
}
| CHAR_T {
   $$ = $1;
   std::cout << $$ << "\n";
}
| STRING_T {
   $$ = $1;
   std::cout << $$ << "\n";
}
| PROC_T {
   $$ = $1;
   std::cout << $$ << "\n";
}
;

%%

void Phobic::Parser::error(const location& loc, const std::string& m) {
   std::cerr << "Syntax Error at[" << repl.location() << "]: " << m << std::endl;
}
