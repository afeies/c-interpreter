#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
INTERPRETER="$PROJECT_DIR/build/cint"
FILTER="${1:-}"

# Build first
echo "Building project..."
make -C "$PROJECT_DIR" > /dev/null 2>&1

if [ ! -x "$INTERPRETER" ]; then
    echo "ERROR: Interpreter not found at $INTERPRETER"
    exit 1
fi

passed=0
failed=0
skipped=0
total=0

# Find all .c test files
while IFS= read -r test_file; do
    # Get path relative to tests dir
    rel_path="${test_file#$SCRIPT_DIR/}"

    # Apply filter if provided
    if [ -n "$FILTER" ] && [[ "$rel_path" != *"$FILTER"* ]]; then
        continue
    fi

    total=$((total + 1))
    expected_file="${test_file%.c}.expected"
    test_name="${rel_path%.c}"

    # Check for .expected file
    if [ ! -f "$expected_file" ]; then
        printf "  SKIP  %s (no .expected file)\n" "$test_name"
        skipped=$((skipped + 1))
        continue
    fi

    # Run the test, capturing stdout+stderr
    actual=$("$INTERPRETER" < "$test_file" 2>&1 || true)
    expected=$(<"$expected_file")

    # Compare
    if diff_output=$(diff -u <(echo "$expected") <(echo "$actual") 2>&1); then
        printf "  PASS  %s\n" "$test_name"
        passed=$((passed + 1))
    else
        printf "  FAIL  %s\n" "$test_name"
        echo "$diff_output"
        echo ""
        failed=$((failed + 1))
    fi
done < <(find "$SCRIPT_DIR" -name '*.c' -type f | sort)

# Summary
echo ""
echo "---"
printf "%d tests: %d passed, %d failed, %d skipped\n" "$total" "$passed" "$failed" "$skipped"

if [ "$failed" -gt 0 ]; then
    exit 1
fi
