all: build/cint

build:
	mkdir -p build

build/lex.yy.c: clang.l build/clang.tab.h | build
	flex -o build/lex.yy.c clang.l

build/clang.tab.c build/clang.tab.h: clang.y | build
	bison -d clang.y -o build/clang.tab.c

build/cint: build/lex.yy.c build/clang.tab.c build/clang.tab.h
	gcc -I build build/lex.yy.c build/clang.tab.c -o build/cint

clean:
	rm -rf build

fact: build/cint
	./build/cint < factorial.c

test: build/cint
	@bash tests/run_tests.sh

test-verbose: build/cint
	@bash tests/run_tests.sh --verbose

run-expr: build/cint
	./build/cint < expr.c

.PHONY: all clean test test-verbose run-expr
