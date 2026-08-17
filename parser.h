/* parser.h - What the bison parser exposes to the rest of the program */

#ifndef PARSER_H
#define PARSER_H

#include <stdio.h>

#include "ast.h"

/* Root of the AST, set by the `program` rule once the whole input parses */
extern ASTNode *root;

extern FILE *yyin;

int yyparse(void);
void yyerror(const char *s);

#endif /* PARSER_H */
