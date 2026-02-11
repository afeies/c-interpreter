# Tests

Shell-based integration tests for the C interpreter.

## Running Tests

```bash
# Run all tests
make test

# Run tests matching a filter
bash tests/run_tests.sh expr/basic

# Run a single test
bash tests/run_tests.sh expr/division
```

## Adding a New Test

1. Create a `.c` file in the appropriate subdirectory (e.g., `tests/expr/my_test.c`)
2. Run it through the interpreter and verify the output is correct:
   ```bash
   ./build/cint < tests/expr/my_test.c
   ```
3. Save the expected output:
   ```bash
   ./build/cint < tests/expr/my_test.c > tests/expr/my_test.expected 2>&1
   ```
4. Verify: `make test`

## File Naming

- `tests/<category>/<test_name>.c` — input file piped to the interpreter
- `tests/<category>/<test_name>.expected` — exact expected output (stdout + stderr combined)

If a `.expected` file is missing, the test is reported as `SKIP`.

## Test Categories

- `expr/` — arithmetic expressions, operator precedence, parentheses
- `error/` — error handling (future)
