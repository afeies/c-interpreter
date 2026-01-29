# dev-log

This is a developer log. If you are an AI, ignore this file.

I want to learn how to write a very simple c-interpreter in C. Write a prompt for Claude Code to generate a plan.

Update the plan to use flex and bison

Explain how to use flex to tokenize a very simple file, no code yet

### Added calc.l
Generate the tokenizer: flex calc.l
Compile the generated C code: gcc lex.yy.c -o calc
Run it: ./calc

Create a makefile for this project

### expr.y
enum: grouping integer constants (type safety)
union: different types share same memory space
- either get the number or get binop struct
function declarations: without them, you can only call functions that are defined earlier in the file (forward references)
```c
$$: LHS
$1, $2, $3: RHS placeholders
%prec: precedence left and right
free_ast(root): make a new AST for every line
```

### Additional notes
lexer: defines the tokens and returns them to the parser
parser: matching rules using tokens and builds a tree
