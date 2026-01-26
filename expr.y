/* expr.y - Expression parser with AST construction */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* AST Node Types */
typedef enum {
    NODE_NUMBER,
    NODE_BINOP
} NodeType;

/* AST Node Structure */
typedef struct ASTNode {
    NodeType type;
    union {
        double number;
        struct {
            char op;  /* '+', '-', '*', '/' */
            struct ASTNode *left;
            struct ASTNode *right;
        } binop;
    } data;
} ASTNode;

/* Function declarations */
ASTNode* make_number(double value);
ASTNode* make_binop(char op, ASTNode *left, ASTNode *right);
void print_ast(ASTNode *node, int indent);
double eval_ast(ASTNode *node);
void free_ast(ASTNode *node);

/* Global root of the AST */
ASTNode *root = NULL;

/* Forward declarations for flex/bison */
int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;

%}

/* Union to hold semantic values */
%union {
    double num;
    ASTNode *node;
}

/* Token declarations */
%token <num> NUMBER
%token NEWLINE

/* Non-terminal types */
%type <node> expression term factor

/* Operator precedence and associativity (lowest to highest) */
%left '+' '-'
%left '*' '/'
%right UMINUS  /* Unary minus */

%%

/* Grammar Rules */

input:
    /* empty */
    | input line
    ;

line:
    NEWLINE
    | expression NEWLINE {
        root = $1;
        printf("AST Structure:\n");
        print_ast(root, 0);
        printf("\nResult: %g\n\n", eval_ast(root));
        free_ast(root);
        root = NULL;
    }
    ;

expression:
    term {
        $$ = $1;
    }
    | expression '+' expression {
        $$ = make_binop('+', $1, $3);
    }
    | expression '-' expression {
        $$ = make_binop('-', $1, $3);
    }
    ;

term:
    factor {
        $$ = $1;
    }
    | term '*' term {
        $$ = make_binop('*', $1, $3);
    }
    | term '/' term {
        $$ = make_binop('/', $1, $3);
    }
    ;

factor:
    NUMBER {
        $$ = make_number($1);
    }
    | '(' expression ')' {
        $$ = $2;
    }
    | '-' factor %prec UMINUS {
        $$ = make_binop('-', make_number(0), $2);
    }
    ;

%%

/* AST Constructor Functions */

ASTNode* make_number(double value) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    node->type = NODE_NUMBER;
    node->data.number = value;
    return node;
}

ASTNode* make_binop(char op, ASTNode *left, ASTNode *right) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    node->type = NODE_BINOP;
    node->data.binop.op = op;
    node->data.binop.left = left;
    node->data.binop.right = right;
    return node;
}

/* Print AST (for visualization) */
void print_ast(ASTNode *node, int indent) {
    if (!node) return;
    
    for (int i = 0; i < indent; i++) printf("  ");
    
    if (node->type == NODE_NUMBER) {
        printf("NUMBER: %g\n", node->data.number);
    } else if (node->type == NODE_BINOP) {
        printf("BINOP: %c\n", node->data.binop.op);
        print_ast(node->data.binop.left, indent + 1);
        print_ast(node->data.binop.right, indent + 1);
    }
}

/* Evaluate AST */
double eval_ast(ASTNode *node) {
    if (!node) return 0;
    
    if (node->type == NODE_NUMBER) {
        return node->data.number;
    } else if (node->type == NODE_BINOP) {
        double left = eval_ast(node->data.binop.left);
        double right = eval_ast(node->data.binop.right);
        
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
    }
    return 0;
}

/* Free AST memory */
void free_ast(ASTNode *node) {
    if (!node) return;
    
    if (node->type == NODE_BINOP) {
        free_ast(node->data.binop.left);
        free_ast(node->data.binop.right);
    }
    free(node);
}

/* Error handling */
void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

/* Main function */
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
    
    yyparse();
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}