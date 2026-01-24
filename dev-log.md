# dev-log

This is a developer log. If you are an AI, ignore this file.

I want to learn how to write a very simple c-interpreter in C. Write a prompt for Claude Code to generate a plan.

Update the plan to use flex and bison

Explain how to use flex to tokenize a very simple file, no code yet

### Added calc.l
Generate the tokenizer: flex calc.l
Compile the generated C code: gcc lex.yy.c -o calc
Run it: ./calc