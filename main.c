/* main.c - Entry point: parse, then run the tree */

#include <stdio.h>

#include "ast.h"
#include "interp.h"
#include "parser.h"

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    }

    printf("Expression Parser with AST\n");
    printf("Enter expressions (Ctrl+D to quit):\n");

    int status = yyparse();

    if (argc > 1) {
        fclose(yyin);
    }

    /* On a parse error the tree is incomplete, so don't run it. */
    if (status != 0) {
        free_ast(root);
        root = NULL;
        return 1;
    }

    printf("AST Structure:\n");
    print_ast(root, 0);
    printf("\nResult: %d\n\n", eval_ast(root));

    free_ast(root);
    root = NULL;

    return 0;
}
