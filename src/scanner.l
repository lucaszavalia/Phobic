%{
   #include <iostream>
   #include <cstdlib>
   #include "scanner.h"
   #include "repl.h"
   #include "parser.hpp"
   #include "location.hh"

   #define yyterminate() Phobic::Parser::make_END(Phobic::location());
   #define YY_USER_ACTION m_repl.increaseLocation(yyleng);
%}

%option c++
%option yylineno
%option noyywrap
%option yyclass="Scanner"
%option prefix="Phobic_"

%%

"<"                           {return Phobic::Parser::make_LAPAR(yytext,Phobic::location());} 
">"                           {return Phobic::Parser::make_RAPAR(yytext,Phobic::location());} 
"("                           {return Phobic::Parser::make_LNPAR(yytext,Phobic::location());} 
")"                           {return Phobic::Parser::make_RNPAR(yytext,Phobic::location());} 
"{"                           {return Phobic::Parser::make_LCPAR(yytext,Phobic::location());} 
"}"                           {return Phobic::Parser::make_RCPAR(yytext,Phobic::location());} 
"["                           {return Phobic::Parser::make_LBPAR(yytext,Phobic::location());}
"]"                           {return Phobic::Parser::make_RBPAR(yytext,Phobic::location());}
"."                           {return Phobic::Parser::make_PERIOD(yytext,Phobic::location());}
","                           {return Phobic::Parser::make_COMMA(yytext,Phobic::location());}
":"                           {return Phobic::Parser::make_COLON(yytext,Phobic::location());}
"::"                          {return Phobic::Parser::make_OBJACC(yytext,Phobic::location());}
"refine"                      {return Phobic::Parser::make_REFINE(yytext,Phobic::location());}
"with"                        {return Phobic::Parser::make_WITH(yytext,Phobic::location());}
"where"                       {return Phobic::Parser::make_WHERE(yytext,Phobic::location());}
":-"                          {return Phobic::Parser::make_PROVES(yytext,Phobic::location());}
"\\"                          {return Phobic::Parser::make_BSLASH(yytext,Phobic::location());}
"import"                      {return Phobic::Parser::make_IMPORT(yytext,Phobic::location());}
"type"                        {return Phobic::Parser::make_TYPE(yytext,Phobic::location());}
"class"                       {return Phobic::Parser::make_CLASS(yytext,Phobic::location());}
"self"                        {return Phobic::Parser::make_SELF(yytext,Phobic::location());}
"constructor"                 {return Phobic::Parser::make_CONSTRUCTOR(yytext,Phobic::location());}
"public"                      {return Phobic::Parser::make_PUBLIC(yytext,Phobic::location());}
"private"                     {return Phobic::Parser::make_PRIVATE(yytext,Phobic::location());}
"protected"                   {return Phobic::Parser::make_PROTECTED(yytext, Phobic::location());}
"agent"                       {return Phobic::Parser::make_AGENT(yytext,Phobic::location());}
"if"                          {return Phobic::Parser::make_IF(yytext,Phobic::location());}
"elif"                        {return Phobic::Parser::make_ELIF(yytext,Phobic::location());}
"else"                        {return Phobic::Parser::make_ELSE(yytext,Phobic::location());}
"switch"                      {return Phobic::Parser::make_SWITCH(yytext,Phobic::location());}
"case"                        {return Phobic::Parser::make_CASE(yytext,Phobic::location());}
"default"                     {return Phobic::Parser::make_DEFAULT(yytext,Phobic::location());}
"new"                         {return Phobic::Parser::make_NEW(yytext,Phobic::location());}
"stop"                        {return Phobic::Parser::make_STOP(yytext,Phobic::location());} 
"assert"                      {return Phobic::Parser::make_ASSERT(yytext,Phobic::location());}
"unsafe"                      {return Phobic::Parser::make_UNSAFE(yytext,Phobic::location());}
"|"                           {return Phobic::Parser::make_PARALLEL(yytext,Phobic::location());} 
"@"                           {return Phobic::Parser::make_DISJOIN(yytext,Phobic::location());} 
"+"                           {return Phobic::Parser::make_ADD(yytext,Phobic::location());}  
"-"                           {return Phobic::Parser::make_SUB(yytext,Phobic::location());}
"*"                           {return Phobic::Parser::make_MUL(yytext,Phobic::location());} 
"/"                           {return Phobic::Parser::make_DIV(yytext,Phobic::location());} 
"%"                           {return Phobic::Parser::make_MOD(yytext,Phobic::location());} 
"and"                         {return Phobic::Parser::make_AND(yytext,Phobic::location());} 
"or"                          {return Phobic::Parser::make_OR(yytext,Phobic::location());} 
"xor"                         {return Phobic::Parser::make_XOR(yytext,Phobic::location());}
"impl"                        {return Phobic::Parser::make_IMPL(yytext,Phobic::location());}
"not"                         {return Phobic::Parser::make_NOT(yytext,Phobic::location());}
"get"                         {return Phobic::Parser::make_GET(yytext,Phobic::location());}
"^"                           {return Phobic::Parser::make_CARET(yytext,Phobic::location());}
"~"                           {return Phobic::Parser::make_TILDE(yytext,Phobic::location());}
"++"                          {return Phobic::Parser::make_CONCAT(yytext,Phobic::location());}
"//"                          {return Phobic::Parser::make_SUBSTR(yytext,Phobic::location());}
"!"                           {return Phobic::Parser::make_OUT(yytext,Phobic::location());}
"?"                           {return Phobic::Parser::make_INP(yytext,Phobic::location());}
"=="                          {return Phobic::Parser::make_EQ(yytext,Phobic::location());} 
"!="                          {return Phobic::Parser::make_NEQ(yytext,Phobic::location());}
">="                          {return Phobic::Parser::make_GEQ(yytext,Phobic::location());}
"<="                          {return Phobic::Parser::make_LEQ(yytext,Phobic::location());}
"<<"                          {return Phobic::Parser::make_STORE(yytext,Phobic::location());}
"True"                        {return Phobic::Parser::make_TRUE(yytext,Phobic::location());} 
"False"                       {return Phobic::Parser::make_FALSE(yytext,Phobic::location());} 
"Int"                         {return Phobic::Parser::make_INT_T(yytext,Phobic::location());} 
"Float"                       {return Phobic::Parser::make_FLOAT_T(yytext,Phobic::location());} 
"Bool"                        {return Phobic::Parser::make_BOOL_T(yytext,Phobic::location());}
"Char"                        {return Phobic::Parser::make_CHAR_T(yytext,Phobic::location());}
"String"                      {return Phobic::Parser::make_STRING_T(yytext,Phobic::location());}
"Lexical"                     {return Phobic::Parser::make_LEX_T(yytext,Phobic::location());}
"Proc"                        {return Phobic::Parser::make_PROC_T(yytext,Phobic::location());}
"Obj"                         {return Phobic::Parser::make_OBJ_T(yytext,Phobic::location());}
"forall"                      {return Phobic::Parser::make_FORALL(yytext,Phobic::location());}
"exists"                      {return Phobic::Parser::make_EXISTS(yytext,Phobic::location());}
"#"                           {return Phobic::Parser::make_HASHTAG(yytext,Phobic::location());}
"$"                           {return Phobic::Parser::make_DOLLAR(yytext,Phobic::location());}
"->"                          {return Phobic::Parser::make_ARROW(yytext,Phobic::location());}
"IO"                          {return Phobic::Parser::make_IO(yytext,Phobic::location());}
"FILE"                        {return Phobic::Parser::make_FILE(yytext,Phobic::location());}
"SOCKET"                      {return Phobic::Parser::make_SOCKET(yytext,Phobic::location());}
"RAND"                        {return Phobic::Parser::make_RAND(yytext,Phobic::location());}
"ENCRYPT"                     {return Phobic::Parser::make_ENCRYPT(yytext,Phobic::location());}
"DECRYPT"                     {return Phobic::Parser::make_DECRYPT(yytext,Phobic::location());}
[0-9]+                        {return Phobic::Parser::make_INT(yytext,Phobic::location());}
[0-9]+"."[0-9]+               {return Phobic::Parser::make_FLOAT(yytext,Phobic::location());}
[a-zA-Z][a-zA-Z0-9_]*         {return Phobic::Parser::make_VAR(yytext,Phobic::location());}
\'([^\\\']|\\.)\'             {return Phobic::Parser::make_CHAR(yytext,Phobic::location());}
\"([^\\\"]|\\.)*\"            {return Phobic::Parser::make_STRING(yytext,Phobic::location());}
`([^`]|\\.)*`
[ \t\n]+                      

<<EOF>>                       {return yyterminate();}

%%




