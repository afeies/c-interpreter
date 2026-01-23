# Plan

I want to build a simple C interpreter in C to learn about:
- Lexical analysis using flex
- Parsing using bison (building an AST)
- Tree-walking interpretation
- Basic memory management

The interpreter should support a minimal subset of C with:

**Data Types:**
- int (32-bit integers)
- Basic pointers (int*)

**Language Features:**
- Variable declarations and assignments
- Arithmetic operations (+, -, *, /, %)
- Comparison operators (<, >, <=, >=, ==, !=)
- Logical operators (&&, ||, !)
- if/else statements
- while loops
- for loops
- Functions (declaration, definition, calls, return values)
- Basic pointer operations (address-of &, dereference *)
- Code blocks with proper scoping

**Example program it should run:**
```c
int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}

int main() {
    int result;
    result = factorial(5);
    return result;
}
```

**Requirements:**
- Written in C (C99 or later)
- Use flex for lexical analysis (tokenization)
- Use bison for parsing (grammar and AST generation)
- Clean separation of lexer (.l), parser (.y), and interpreter modules
- Basic error reporting with line numbers
- Well-commented code for educational purposes
- A simple test suite with example programs
- Include Makefile for building with flex/bison

**Out of scope:**
- No standard library functions (printf, malloc, etc.)
- No arrays or strings
- No structs or unions
- No preprocessor directives
- No floating-point support

Please create a plan for implementing this interpreter with:
1. The overall architecture and module structure (flex/bison/interpreter)
2. Data structures for AST nodes and runtime values
3. Flex lexer specification (.l file) and Bison parser specification (.y file)
4. Implementation phases in logical order
5. Testing strategy for each phase
6. Critical files that will be created (including Makefile)
