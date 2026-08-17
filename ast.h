/* ast.h - AST node types and constructors */

#ifndef AST_H
#define AST_H

/* AST Node Types */
typedef enum {
    NODE_NUMBER,
    NODE_BINOP,
    NODE_BLOCK,
    NODE_SCOPE
} NodeType;

/* AST Node Structure */
typedef struct ASTNode {
    NodeType type;
    union {
        int number;
        struct {
            char op;  /* '+', '-', '*', '/' */
            struct ASTNode *left;
            struct ASTNode *right;
        } binop;
        struct {
            struct ASTNode **items;
            int count;
            int capacity;
        } block;
        struct {
            struct ASTNode *body;   /* the statement_list inside the braces */
        } scope;
    } data;
} ASTNode;

/* Constructors */
ASTNode* make_number(int value);
ASTNode* make_binop(char op, ASTNode *left, ASTNode *right);
ASTNode* make_block(void);
ASTNode* make_scope(ASTNode *body);

/* Append a statement to a block, growing the array as needed */
void block_append(ASTNode *block, ASTNode *stmt);

void print_ast(ASTNode *node, int indent);
void free_ast(ASTNode *node);

#endif /* AST_H */
