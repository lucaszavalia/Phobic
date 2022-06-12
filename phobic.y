%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "structures.h"

extern int yylex();
extern int lineno;

struct AST * parsedTree;
int yyerror(char * s);
%}

%union {
   struct AST * ptree;
   char * var;
}

%start program
%token<var> LAPAR RAPAR LRPAR RRPAR LBPAR RBPAR LSPAR RSPAR PERIOD COMMA COLON BSLASH DEFMACRO SILENT IF NEW PARALLEL DISJOIN REPLICATE STOP ADD SUB MUL DIV MOD NOT OR AND EQ NEQ TRUE FALSE INT_T FLOAT_T BOOL_T CHAR_T STRING_T PROC_T INT FLOAT VAR CHAR STRING PAR FAPP SEND RECEIVE
%type<ptree> terminal term btype type vardef vdef varterm vterm comp pcalc prog definitions program

%left ADD
%left SUB
%left MUL
%left DIV
%left MOD
%left AND
%left OR
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

%%

program : prog {parsedTree = $1;}
| definitions {parsedTree = $1;}
;

prog : LBPAR DEFMACRO VAR vdef RBPAR LSPAR pcalc RSPAR prog {
   struct AST * subtree = new_node(DEFMACRO, $2);
   struct AST * temp = new_node(VAR, $3);
   concat_ast(subtree, temp);
   concat_ast(subtree, $4);
   concat_ast(subtree, $7);
   concat_ast(subtree, $9);
   $$ = subtree;
}
| pcalc {$$ = $1;}
;

definitions : LBPAR DEFMACRO VAR vdef RBPAR LSPAR pcalc RSPAR definitions {
   struct AST * subtree = new_node(DEFMACRO, $2);
   struct AST * temp = new_node(VAR, $3);
   concat_ast(subtree, temp);
   concat_ast(subtree, $4);
   concat_ast(subtree, $7);
   concat_ast(subtree, $9);
   $$ = subtree;
}
| LBPAR DEFMACRO VAR vdef RBPAR LSPAR pcalc RSPAR {
   struct AST * subtree = new_node(DEFMACRO, $2);
   struct AST * temp = new_node(VAR, $3);
   concat_ast(subtree, temp);
   concat_ast(subtree, $4);
   concat_ast(subtree, $7);
   $$ = subtree;
}
;

pcalc : VAR LAPAR vterm RAPAR PERIOD pcalc %prec SND {
   printf("TEST IS %s\n", $2);
   struct AST * subtree = new_node(SEND, $1);
   concat_ast(subtree, $3);
   concat_ast(subtree, $6);
   $$ = subtree;
}
| VAR LRPAR vterm RRPAR PERIOD pcalc %prec RCV {
   struct AST * subtree = new_node(RECEIVE, $1);
   concat_ast(subtree, $3);
   concat_ast(subtree, $6);
   $$ = subtree;
}
| SILENT PERIOD pcalc %prec IFF {
   struct AST * subtree = new_node(SILENT, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| LBPAR IF comp RBPAR LSPAR pcalc RSPAR PERIOD pcalc %prec IFF {
   struct AST * subtree = new_node(IF, $2);
   concat_ast(subtree, $3);
   concat_ast(subtree, $6);
   concat_ast(subtree, $9);
   $$ = subtree;
}
| LBPAR NEW vdef RBPAR LSPAR pcalc RSPAR {
   struct AST * subtree = new_node(NEW, $2);
   concat_ast(subtree, $3);
   concat_ast(subtree, $6);
   $$ = subtree;
}
| LBPAR VAR RBPAR LSPAR vterm RSPAR PERIOD pcalc %prec FAP {
   struct AST * subtree = new_node(FAPP, $2);
   concat_ast(subtree, $5);
   concat_ast(subtree, $8);
   $$ = subtree;
}
| pcalc PARALLEL pcalc {
   struct AST * subtree = new_node(PARALLEL, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| pcalc DISJOIN pcalc {
   struct AST * subtree = new_node(DISJOIN, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| pcalc DISJOIN LSPAR term RSPAR pcalc %prec PDJ {
   struct AST * subtree = new_node(DISJOIN, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $4);
   concat_ast(subtree, $6);
   $$ = subtree;
}
| REPLICATE pcalc %prec REP {
   struct AST * subtree = new_node(REPLICATE, $1);
   concat_ast(subtree, $2);
   $$ = subtree;
}
| STOP {
   struct AST * subtree = new_node(STOP, $1);
   $$ = subtree;
}
;

vterm : varterm COMMA vterm {
   struct AST * subtree = new_node(COMMA, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| varterm {$$ = $1;}
;

varterm : term {$$ = $1;}
| pcalc {$$ = $1;}
;

comp : varterm EQ varterm {
   struct AST * subtree = new_node(EQ, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| varterm NEQ varterm {
   struct AST * subtree = new_node(NEQ, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
;

term : term ADD term {
   struct AST * subtree = new_node(ADD, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| term SUB term {
   struct AST * subtree = new_node(SUB, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| term MUL term {
   struct AST * subtree = new_node(MUL, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| term DIV term {
   struct AST * subtree = new_node(DIV, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| term MOD term {
   struct AST * subtree = new_node(MOD, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| term AND term {
   struct AST * subtree = new_node(AND, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| term OR term {
   struct AST * subtree = new_node(OR, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| LRPAR term RRPAR {
   struct AST * subtree = new_node(PAR, NULL);
   concat_ast(subtree, $2);
   $$ = subtree;
}
| NOT term %prec NEG {
   struct AST * subtree = new_node(NOT, $1);
   concat_ast(subtree, $2);
   $$ = subtree;
}
| terminal {$$ = $1;}
;

terminal : INT {
   struct AST * subtree = new_node(INT, $1);
   $$ = subtree;
}
| FLOAT {
   struct AST * subtree = new_node(FLOAT, $1);
   $$ = subtree;
}
| TRUE {
   struct AST * subtree = new_node(TRUE, $1);
   $$ = subtree;
}
| FALSE {
   struct AST * subtree = new_node(FALSE, $1);
   $$ = subtree;
}
| CHAR {
   struct AST * subtree = new_node(CHAR, $1);
   $$ = subtree;
}
| STRING {
   struct AST * subtree = new_node(STRING, $1);
   $$ = subtree;
}
| VAR {
   struct AST * subtree = new_node(VAR, $1);
   $$ = subtree;
}
;

vdef : vardef COMMA vdef {
   struct AST * subtree = new_node(COMMA, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| vardef {$$ = $1;}
;

vardef : VAR COLON type {
   struct AST * subtree = new_node(COLON, $2);
   struct AST * temp = new_node(VAR, $1);
   concat_ast(subtree, temp);
   concat_ast(subtree, $3);
   $$ = subtree;
}
;

type : btype BSLASH type {
   struct AST * subtree = new_node(BSLASH, $2);
   concat_ast(subtree, $1);
   concat_ast(subtree, $3);
   $$ = subtree;
}
| btype {$$ = $1;}
;

btype : INT_T {
   struct AST * subtree = new_node(INT_T, $1);
   $$ = subtree;
}
| FLOAT_T {
   struct AST * subtree = new_node(FLOAT_T, $1);
   $$ = subtree;
}
| BOOL_T {
   struct AST * subtree = new_node(BOOL_T, $1);
   $$ = subtree;
}
| CHAR_T {
   struct AST * subtree = new_node(CHAR_T, $1);
   $$ = subtree;
}
| STRING_T {
   struct AST * subtree = new_node(STRING_T, $1);
   $$ = subtree;
}
| PROC_T {
   struct AST * subtree = new_node(PROC_T, $1);
   $$ = subtree;
}
;

%%

int yyerror(char * s) {
  extern int yylineno;
  extern char *yytext;
  printf("ERROR: %s at symbol \"%s", s, yytext);
  printf("\" on line %d\n", lineno);
  exit(1);
}
