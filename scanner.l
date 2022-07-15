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

%option noyywrap
%option c++
%option yyclass="Scanner"
%option prefix="Phobic_"

%%

"<"                           {return Phobic::Parser::make_LAPAR(yytext,Phobic::location());} 
">"                           {return Phobic::Parser::make_RAPAR(yytext,Phobic::location());} 
"("                           {return Phobic::Parser::make_LNPAR(yytext,Phobic::location());} 
")"                           {return Phobic::Parser::make_RNPAR(yytext,Phobic::location());} 
"["                           {return Phobic::Parser::make_LBPAR(yytext,Phobic::location());} 
"]"                           {return Phobic::Parser::make_RBPAR(yytext,Phobic::location());} 
"{"                           {return Phobic::Parser::make_LCPAR(yytext,Phobic::location());} 
"}"                           {return Phobic::Parser::make_RCPAR(yytext,Phobic::location());} 
"."                           {return Phobic::Parser::make_PERIOD(yytext,Phobic::location());} 
","                           {return Phobic::Parser::make_COMMA(yytext,Phobic::location());} 
":"                           {return Phobic::Parser::make_COLON(yytext,Phobic::location());} 
"\\"                          {return Phobic::Parser::make_BSLASH(yytext,Phobic::location());} 
"def-macro"                   {return Phobic::Parser::make_DEFMACRO(yytext,Phobic::location());} 
"wait"                        {return Phobic::Parser::make_WAIT(yytext,Phobic::location());} 
"if"                          {return Phobic::Parser::make_IF(yytext,Phobic::location());} 
"new"                         {return Phobic::Parser::make_NEW(yytext,Phobic::location());} 
"stop"                        {return Phobic::Parser::make_STOP(yytext,Phobic::location());} 
"$"                           {return Phobic::Parser::make_PARALLEL(yytext,Phobic::location());} 
"@"                           {return Phobic::Parser::make_DISJOIN(yytext,Phobic::location());} 
"!"                           {return Phobic::Parser::make_REPLICATE(yytext,Phobic::location());} 
"+"                           {return Phobic::Parser::make_ADD(yytext,Phobic::location());}  
"-"                           {return Phobic::Parser::make_SUB(yytext,Phobic::location());}
"*"                           {return Phobic::Parser::make_MUL(yytext,Phobic::location());} 
"/"                           {return Phobic::Parser::make_DIV(yytext,Phobic::location());} 
"%"                           {return Phobic::Parser::make_MOD(yytext,Phobic::location());} 
"&"                           {return Phobic::Parser::make_AND(yytext,Phobic::location());} 
"|"                           {return Phobic::Parser::make_OR(yytext,Phobic::location());} 
"~"                           {return Phobic::Parser::make_NOT(yytext,Phobic::location());} 
"=="                          {return Phobic::Parser::make_EQ(yytext,Phobic::location());} 
"!="                          {return Phobic::Parser::make_NEQ(yytext,Phobic::location());} 
"True"                        {return Phobic::Parser::make_TRUE(yytext,Phobic::location());}        
"False"                       {return Phobic::Parser::make_FALSE(yytext,Phobic::location());} 
"Int"                         {return Phobic::Parser::make_INT_T(yytext,Phobic::location());} 
"Float"                       {return Phobic::Parser::make_FLOAT_T(yytext,Phobic::location());} 
"Bool"                        {return Phobic::Parser::make_BOOL_T(yytext,Phobic::location());}
"Char"                        {return Phobic::Parser::make_CHAR_T(yytext,Phobic::location());}
"String"                      {return Phobic::Parser::make_STRING_T(yytext,Phobic::location());}
"Proc"                        {return Phobic::Parser::make_PROC_T(yytext,Phobic::location());}
[0-9]+                        {return Phobic::Parser::make_INT(yytext,Phobic::location());}
[0-9]+"."[0-9]+               {return Phobic::Parser::make_FLOAT(yytext,Phobic::location());}
[a-zA-Z][a-zA-Z0-9_]*         {return Phobic::Parser::make_VAR(yytext,Phobic::location());}
"'"."'"                       {return Phobic::Parser::make_CHAR(yytext,Phobic::location());}
"\"".*"\""                    {return Phobic::Parser::make_STRING(yytext,Phobic::location());}
[ \t\n]+

<<EOF>>                       {return yyterminate();}

%%
