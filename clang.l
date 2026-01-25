%{
/* DEFINITIONS SECTION - C code between %{ and %} */
#include <stdio.h>
%}

/* Pattern definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%
"int"           { printf("KEYWORD: %s\n", yytext); }

{IDENTIFIER}    { printf("IDENTIFIER: %s\n", yytext); }

[0-9]+          { printf("NUMBER: %s\n", yytext); }
"+"             { printf("PLUS\n"); }
"-"             { printf("MINUS\n"); }
"*"             { printf("MULTIPLY\n"); }
"/"             { printf("DIVIDE\n"); }

"<"             { printf("LESS_THAN\n"); }
">"             { printf("GREATER_THAN\n"); }
"<="            { printf("LESS_EQUAL\n"); }
">="            { printf("GREATER_EQUAL\n"); }
"="             { printf("ASSIGN\n"); }

"("             { printf("LPAREN\n"); }
")"             { printf("RPAREN\n"); }

"{"             { printf("LBRACE\n"); }
"}"             { printf("RBRACE\n"); }

";"             { printf("SEMICOLON\n"); }

[ \t\n]         { /* skip whitespace */ }
.               { printf("UNKNOWN: %s\n", yytext); }

%%
/* USER CODE SECTION - additional C functions */

int main() {
    yylex();  /* Start tokenizing */
    return 0;
}

int yywrap() {
    return 1;  /* Return 1 when done with input */
}