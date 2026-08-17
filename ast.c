/* ast.c - AST construction, printing, and teardown */

#include <stdio.h>
#include <stdlib.h>

#include "ast.h"

/* AST Constructor Functions */

static ASTNode* new_node(NodeType type) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    node->type = type;
    return node;
}

ASTNode* make_number(int value) {
    ASTNode *node = new_node(NODE_NUMBER);
    node->data.number = value;
    return node;
}

ASTNode* make_binop(char op, ASTNode *left, ASTNode *right) {
    ASTNode *node = new_node(NODE_BINOP);
    node->data.binop.op = op;
    node->data.binop.left = left;
    node->data.binop.right = right;
    return node;
}

ASTNode* make_block(void) {
    ASTNode *node = new_node(NODE_BLOCK);
    node->data.block.items = NULL;
    node->data.block.count = 0;
    node->data.block.capacity = 0;
    return node;
}

ASTNode* make_scope(ASTNode *body) {
    ASTNode *node = new_node(NODE_SCOPE);
    node->data.scope.body = body;
    return node;
}

/* Append a statement to a block, growing the array as needed */
void block_append(ASTNode *block, ASTNode *stmt) {
    if (!stmt) return;  /* empty statements contribute nothing */

    if (block->data.block.count == block->data.block.capacity) {
        int new_capacity = block->data.block.capacity ? block->data.block.capacity * 2 : 4;
        ASTNode **items = (ASTNode**)realloc(block->data.block.items,
                                             new_capacity * sizeof(ASTNode*));
        if (!items) {
            fprintf(stderr, "Out of memory\n");
            exit(1);
        }
        block->data.block.items = items;
        block->data.block.capacity = new_capacity;
    }

    block->data.block.items[block->data.block.count++] = stmt;
}

/* Print AST (for visualization) */
void print_ast(ASTNode *node, int indent) {
    if (!node) return;

    for (int i = 0; i < indent; i++) printf("  ");

    if (node->type == NODE_NUMBER) {
        printf("NUMBER: %d\n", node->data.number);
    } else if (node->type == NODE_BINOP) {
        printf("BINOP: %c\n", node->data.binop.op);
        print_ast(node->data.binop.left, indent + 1);
        print_ast(node->data.binop.right, indent + 1);
    } else if (node->type == NODE_BLOCK) {
        printf("BLOCK (%d statements)\n", node->data.block.count);
        for (int i = 0; i < node->data.block.count; i++) {
            print_ast(node->data.block.items[i], indent + 1);
        }
    } else if (node->type == NODE_SCOPE) {
        printf("SCOPE\n");
        print_ast(node->data.scope.body, indent + 1);
    }
}

/* Free AST memory */
void free_ast(ASTNode *node) {
    if (!node) return;

    if (node->type == NODE_BINOP) {
        free_ast(node->data.binop.left);
        free_ast(node->data.binop.right);
    } else if (node->type == NODE_BLOCK) {
        for (int i = 0; i < node->data.block.count; i++) {
            free_ast(node->data.block.items[i]);
        }
        free(node->data.block.items);
    } else if (node->type == NODE_SCOPE) {
        free_ast(node->data.scope.body);
    }
    free(node);
}
