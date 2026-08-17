/* clang.y - Expression parser with AST construction */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ast.h"

/* Global root of the AST */
ASTNode *root = NULL;

/* Forward declarations for flex/bison */
int yylex_impl(void);  /* Real lexer from flex */
int yylex(void);       /* Our wrapper */
void yyerror(const char *s);
extern FILE *yyin;

%}

/* Enable location tracking */
%locations

/* Union to hold semantic values.
   ASTNode stays an incomplete type here: clang.tab.h is included by the lexer,
   which only ever touches .num and .str, so a bare pointer is enough. */
%union {
    int num;
    char *str;
    struct ASTNode *node;
}

/* Token declarations */
%token <num> NUMBER
%token <str> IDENTIFIER
%token INT VOID SIZEOF IF ELSE WHILE FOR RETURN
%token PLUS MINUS MULT DIV MOD
%token LT GT LE GE EQ NE ASSIGN
%token AND OR NOT
%token BITAND BITOR BITXOR BITNOT LSHIFT RSHIFT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN
%token INC DEC
%token COMMA STRING_LITERAL CHAR_CONSTANT

/* Non-terminal types */
%type <node> expression term factor
%type <node> statement_list statement block

/* Operator precedence and associativity (lowest to highest) */
%left PLUS MINUS
%left MULT DIV
%right UMINUS  /* Unary minus */

%%

/* Grammar Rules */

/* Building the tree is all the parser does. main() runs it afterwards, once
   yyparse() has confirmed the whole input actually parsed. */
program:
    statement_list { root = $1; }
    ;

statement_list:
    /* empty */                 { $$ = make_block(); }
    | statement_list statement  { block_append($1, $2); $$ = $1; }
    ;

statement:
    expression SEMICOLON  { $$ = $1; }
    | block               { $$ = $1; }
    ;

block:
    LBRACE statement_list RBRACE  { $$ = make_scope($2); }
    ;

expression:
    term {
        $$ = $1;
    }
    | expression PLUS expression {
        $$ = make_binop('+', $1, $3);
    }
    | expression MINUS expression {
        $$ = make_binop('-', $1, $3);
    }
    ;

term:
    factor {
        $$ = $1;
    }
    | term MULT term {
        $$ = make_binop('*', $1, $3);
    }
    | term DIV term {
        $$ = make_binop('/', $1, $3);
    }
    ;

factor:
    NUMBER {
        $$ = make_number($1);
    }
    | LPAREN expression RPAREN {
        $$ = $2;
    }
    | MINUS factor %prec UMINUS {
        $$ = make_binop('-', make_number(0), $2);
    }
    ;

%%

/* Token name lookup */
const char* token_name(int token) {
    switch(token) {
        case NUMBER: return "NUMBER";
        case IDENTIFIER: return "IDENTIFIER";
        case INT: return "INT";
        case PLUS: return "PLUS";
        case MINUS: return "MINUS";
        case MULT: return "MULT";
        case DIV: return "DIV";
        case MOD: return "MOD";
        case LT: return "LT";
        case GT: return "GT";
        case LE: return "LE";
        case GE: return "GE";
        case EQ: return "EQ";
        case NE: return "NE";
        case ASSIGN: return "ASSIGN";
        case AND: return "AND";
        case OR: return "OR";
        case NOT: return "NOT";
        case BITAND: return "BITAND";
        case BITOR: return "BITOR";
        case BITXOR: return "BITXOR";
        case BITNOT: return "BITNOT";
        case LSHIFT: return "LSHIFT";
        case RSHIFT: return "RSHIFT";
        case LPAREN: return "LPAREN";
        case RPAREN: return "RPAREN";
        case LBRACE: return "LBRACE";
        case RBRACE: return "RBRACE";
        case SEMICOLON: return "SEMICOLON";
        case PLUS_ASSIGN: return "PLUS_ASSIGN";
        case MINUS_ASSIGN: return "MINUS_ASSIGN";
        case MULT_ASSIGN: return "MULT_ASSIGN";
        case DIV_ASSIGN: return "DIV_ASSIGN";
        case MOD_ASSIGN: return "MOD_ASSIGN";
        case INC: return "INC";
        case DEC: return "DEC";
        case COMMA: return "COMMA";
        case STRING_LITERAL: return "STRING_LITERAL";
        case CHAR_CONSTANT: return "CHAR_CONSTANT";
        default: return "UNKNOWN";
    }
}

/* Wrapper to print tokens */
int yylex(void) {
    int token = yylex_impl();
    if (token != 0) {
        printf("TOKEN: %s", token_name(token));
        if (token == NUMBER) {
            printf(" (%d)", yylval.num);
        } else if (token == IDENTIFIER) {
            printf(" (%s)", yylval.str);
        }
        printf("\n");
    }
    return token;
}

/* Error handling with line number */
void yyerror(const char *s) {
    fprintf(stderr, "Parse error at line %d: %s\n", yylloc.first_line, s);
}
