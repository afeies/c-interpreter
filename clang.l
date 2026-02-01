%{
/* DEFINITIONS SECTION - C code between %{ and %} */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "clang.tab.h"

/* Macro to track line numbers for each token */
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;

/* Rename yylex to yylex_impl so we can wrap it */
#define yylex yylex_impl
%}

/* Enable line number tracking */
%option yylineno

/* Pattern definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%
"int"           { return INT; }

{IDENTIFIER}    { yylval.str = strdup(yytext); return IDENTIFIER; }

[0-9]+          { yylval.num = atof(yytext); return NUMBER; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULT; }
"/"             { return DIV; }

"<"             { return LT; }
">"             { return GT; }
"<="            { return LE; }
">="            { return GE; }
"="             { return ASSIGN; }

"("             { return LPAREN; }
")"             { return RPAREN; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }

";"             { return SEMICOLON; }

[ \t]+          { /* skip whitespace */ }
\n              { return NEWLINE; }
.               { /* ignore unknown characters for now */ }

%%
/* USER CODE SECTION - additional C functions */

int yywrap() {
    return 1;  /* Return 1 when done with input */
}