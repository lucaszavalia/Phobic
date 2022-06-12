%{
#include "phobic.tab.h"
#include <string.h>

extern int yyerror(char * s);
int lineno = 1;
int yylex();
%}

%%

"<"                     {yylval.var = strdup(yytext); return LAPAR;}
">"                     {yylval.var = strdup(yytext); return RAPAR;}
"("                     {yylval.var = strdup(yytext); return LRPAR;}
")"                     {yylval.var = strdup(yytext); return RRPAR;}
"["                     {yylval.var = strdup(yytext); return LBPAR;}
"]"                     {yylval.var = strdup(yytext); return RBPAR;}
"{"                     {yylval.var = strdup(yytext); return LSPAR;}
"}"                     {yylval.var = strdup(yytext); return RSPAR;}
"."                     {yylval.var = strdup(yytext); return PERIOD;}
","                     {yylval.var = strdup(yytext); return COMMA;}
":"                     {yylval.var = strdup(yytext); return COLON;}
"\\"                    {yylval.var = strdup(yytext); return BSLASH;}
"def-macro"             {yylval.var = strdup(yytext); return DEFMACRO;}
"silent"                {yylval.var = strdup(yytext); return SILENT;}
"if"                    {yylval.var = strdup(yytext); return IF;}
"new"                   {yylval.var = strdup(yytext); return NEW;}
"$"                     {yylval.var = strdup(yytext); return PARALLEL;}
"@"                     {yylval.var = strdup(yytext); return DISJOIN;}
"!"                     {yylval.var = strdup(yytext); return REPLICATE;}
"_"                     {yylval.var = strdup(yytext); return STOP;}
"+"                     {yylval.var = strdup(yytext); return ADD;}
"-"                     {yylval.var = strdup(yytext); return SUB;}
"*"                     {yylval.var = strdup(yytext); return MUL;}
"/"                     {yylval.var = strdup(yytext); return DIV;}
"%"                     {yylval.var = strdup(yytext); return MOD;}
"~"                     {yylval.var = strdup(yytext); return NOT;}
"|"                     {yylval.var = strdup(yytext); return OR;}
"&"                     {yylval.var = strdup(yytext); return AND;}
"=="                    {yylval.var = strdup(yytext); return EQ;}
"!="                    {yylval.var = strdup(yytext); return NEQ;}
"True"                  {yylval.var = strdup(yytext); return TRUE;}
"False"                 {yylval.var = strdup(yytext); return FALSE;}
"Int"                   {yylval.var = strdup(yytext); return INT_T;}
"Float"                 {yylval.var = strdup(yytext); return FLOAT_T;}
"Bool"                  {yylval.var = strdup(yytext); return BOOL_T;}
"Char"                  {yylval.var = strdup(yytext); return CHAR_T;}
"String"                {yylval.var = strdup(yytext); return STRING_T;}
"Proc"                  {yylval.var = strdup(yytext); return PROC_T;}
[0-9]+                  {yylval.var = strdup(yytext); return INT;}
[0-9]+"."[0-9]+         {yylval.var = strdup(yytext); return FLOAT;}
[a-zA-Z][a-zA-Z0-9]*    {yylval.var = strdup(yytext); return VAR;}
"'"."'"                 {yylval.var = strdup(yytext); return CHAR;}
"\"".*"\""              {yylval.var = strdup(yytext); return STRING;}
"\n"                    {lineno++;}

%%

int yywrap(void) {return 1;}
