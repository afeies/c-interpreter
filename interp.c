/* interp.c - Tree-walking evaluator */

#include <stdio.h>
#include <stdlib.h>

#include "interp.h"

/* Evaluate AST */
int eval_ast(ASTNode *node) {
    if (!node) return 0;

    if (node->type == NODE_NUMBER) {
        return node->data.number;
    } else if (node->type == NODE_BINOP) {
        int left = eval_ast(node->data.binop.left);
        int right = eval_ast(node->data.binop.right);

        switch (node->data.binop.op) {
            case '+': return left + right;
            case '-': return left - right;
            case '*': return left * right;
            case '/':
                if (right == 0) {
                    fprintf(stderr, "Division by zero\n");
                    exit(1);
                }
                return left / right;
            default:
                fprintf(stderr, "Unknown operator: %c\n", node->data.binop.op);
                exit(1);
        }
    } else if (node->type == NODE_BLOCK) {
        int result = 0;
        for (int i = 0; i < node->data.block.count; i++) {
            result = eval_ast(node->data.block.items[i]);
        }
        return result;
    } else if (node->type == NODE_SCOPE) {
        /* push_scope() goes here once the symbol table exists */
        int result = eval_ast(node->data.scope.body);
        /* pop_scope() goes here */
        return result;
    }
    return 0;
}
