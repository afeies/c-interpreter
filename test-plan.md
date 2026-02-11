# Unit Test Infrastructure Plan

## Overview

Add a shell-based test infrastructure for the C interpreter. Tests are `.c` input files piped through the interpreter binary, with expected output compared against `.expected` files. A single `tests/run_tests.sh` script acts as the test runner, producing simple pass/fail output.

Zero external dependencies required — just bash, diff, and the existing build system.

---

## Directory Structure

```
tests/
├── run_tests.sh          # Test runner script
├── expr/                  # Expression/arithmetic tests
│   ├── basic_add.c
│   ├── basic_add.expected
│   ├── basic_mul.c
│   ├── basic_mul.expected
│   ├── ...
├── error/                 # Error handling tests (future)
│   ├── div_zero.c
│   ├── div_zero.expected
│   └── ...
└── README.md              # How to write and run tests
```

---

## Tasks

### Task 1: Create the test runner script (`tests/run_tests.sh`)

Write a bash script that:

1. **Discovers tests** — finds all `*.c` files under `tests/` recursively
2. **Runs each test** — pipes the `.c` file through `build/cint`
3. **Compares output** — diffs actual output (stdout + stderr) against the matching `.expected` file
4. **Reports results** — prints each test name with `PASS` or `FAIL`, shows diff on failure
5. **Prints summary** — total tests, passed, failed; exits with non-zero on any failure

Behavior details:
- If a `.expected` file is missing, report the test as `SKIP` (new tests in progress)
- Capture both stdout and stderr from the interpreter (combined)
- Use `diff -u` for readable failure output
- The script should build the project first (`make`) so it can be run standalone
- Support an optional filter argument: `./tests/run_tests.sh expr/basic` runs only matching tests

### Task 2: Write initial test cases for current functionality

Create test `.c` files and corresponding `.expected` files covering the current expression parser:

| Test file | Input | What it tests |
|---|---|---|
| `expr/basic_add.c` | `1 + 2` | Simple addition |
| `expr/basic_mul.c` | `3 * 4` | Simple multiplication |
| `expr/precedence.c` | `2 + 3 * 4` | Operator precedence (* before +) |
| `expr/parens.c` | `(2 + 3) * 4` | Parenthesized expressions |
| `expr/unary_neg.c` | `-5 + 3` | Unary minus |
| `expr/nested.c` | `(1 + 2) * (5 + 6) * -1` | Complex nested expression (current `expr.c`) |
| `expr/division.c` | `10 / 3` | Integer division behavior |

For each test:
- The `.c` file contains the expression followed by a newline
- The `.expected` file contains the exact expected output (TOKEN lines, AST printout, Result line)

To generate the `.expected` files: build the interpreter, run each `.c` file through it, verify the output is correct, then save it.

### Task 3: Add `make test` and `make test-all` targets

Update the `makefile`:

- **`make test`** — runs `tests/run_tests.sh` (replaces the current single-file test)
- **`make test-verbose`** — runs tests with verbose diff output on failure
- Keep the old behavior available as `make run-expr` or similar if desired

```makefile
test: build/cint
	@bash tests/run_tests.sh

test-verbose: build/cint
	@bash tests/run_tests.sh --verbose
```

### Task 4: Update CLAUDE.md

Update the CLAUDE.md documentation to reflect:

- New test infrastructure in the **Development Workflow** section
- How to run tests (`make test`)
- How to add a new test (create `.c` and `.expected` files)
- Updated **Key Files** section to include `tests/` directory

### Task 5: Add tests/README.md

Create a brief `tests/README.md` covering:

- How to run all tests
- How to run a subset of tests
- How to add a new test case
- Expected file format and naming conventions

---

## Design Decisions

**Why shell-based over a C framework?**
- Zero dependencies — no `brew install` needed
- Tests the interpreter end-to-end as a user would use it
- Dead simple to add new tests: write a `.c` file and an `.expected` file
- Matches the project's learning-oriented, minimal style
- As the interpreter grows, these integration tests remain valuable even if C unit tests are added later

**Why `.expected` files over inline assertions?**
- Easy to inspect and update
- `diff -u` gives clear failure output
- Captures the full output including TOKEN logging and AST structure
- Can be regenerated with a single command when output format intentionally changes

**Why combined stdout+stderr?**
- The interpreter currently prints errors to stderr (parse errors, division by zero)
- Error-case tests need to assert on stderr content
- Simplest approach: capture both, match against expected

---

## Future Considerations (out of scope for now)

- **Snapshot update command** — `./tests/run_tests.sh --update` to regenerate all `.expected` files
- **CI integration** — run `make test` in a GitHub Actions workflow
- **Timeout** — kill tests that hang (infinite loops in interpreted code)
- **Exit code tests** — assert interpreter exit code (e.g., division by zero should exit 1)
- **C unit tests** — once AST/eval are extracted to headers, add `assert.h`-based tests for internals
