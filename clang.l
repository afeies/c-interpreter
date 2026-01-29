%{
/* DEFINITIONS SECTION - C code between %{ and %} */
#include <stdio.h>
#include <stdlib.h>
#include "expr.tab.h"
%}

/* Pattern definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%
"int"           { /* keyword - not yet used by parser */ }

{IDENTIFIER}    { /* identifier - not yet used by parser */ }

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