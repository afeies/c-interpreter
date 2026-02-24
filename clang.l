%{
/* DEFINITIONS SECTION - C code between %{ and %} */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "clang.tab.h"

extern YYLTYPE yylloc;

int parse_escape_sequence(const char *text);

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
"void"          { return VOID; }
"sizeof"        { return SIZEOF; }

"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"for"           { return FOR; }
"return"        { return RETURN; }

{IDENTIFIER}    { yylval.str = strdup(yytext); return IDENTIFIER; }

[0-9]+          { yylval.num = atof(yytext); return NUMBER; }

"//".*          { /* skip single-line comments */ }
"/*"([^*]|(\*+[^*/]))*\*+"/"    { /* skip multi-line comments */ }

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULT; }
"/"             { return DIV; }
"%"             { return MOD; }

"&&"            { return AND; }
"||"            { return OR; }
"!"             { return NOT; }

"&"             { return BITAND; }
"|"             { return BITOR; }
"^"             { return BITXOR; }
"~"             { return BITNOT; }
"<<"            { return LSHIFT; }
">>"            { return RSHIFT; }

"<"             { return LT; }
">"             { return GT; }
"<="            { return LE; }
">="            { return GE; }
"=="            { return EQ; }
"!="            { return NE; }
"="             { return ASSIGN; }
"+="            { return PLUS_ASSIGN; }
"-="            { return MINUS_ASSIGN; }
"*="            { return MULT_ASSIGN; }
"/="            { return DIV_ASSIGN; }
"%="            { return MOD_ASSIGN; }
"++"            { return INC; }
"--"            { return DEC; }

"("             { return LPAREN; }
")"             { return RPAREN; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }

";"             { return SEMICOLON; }
","             { return COMMA; }

\"([^\\\"]|\\.)*\"    { 
    yylval.str = strdup(yytext); 
    return STRING_LITERAL; 
}

\'([^\\\']|\\.)\'    { 
    yylval.num = yytext[1] == '\\' ? parse_escape_sequence(yytext) : yytext[1];
    return CHAR_CONSTANT; 
}

[ \t]+          { /* skip whitespace */ }
\n              { return NEWLINE; }
.               { /* ignore unknown characters for now */ }


%%
/* USER CODE SECTION - additional C functions */

int yywrap() {
    return 1;  /* Return 1 when done with input */
}

int parse_escape_sequence(const char *text) {
    /* text is like '\n' — the escape char is at index 2 */
    switch (text[2]) {
        case 'n':  return '\n';
        case 't':  return '\t';
        case 'r':  return '\r';
        case '\\': return '\\';
        case '\'': return '\'';
        case '\"': return '\"';
        case '0':  return '\0';
        case 'a':  return '\a';
        case 'b':  return '\b';
        case 'f':  return '\f';
        case 'v':  return '\v';
        default:   return text[2];
    }
}

