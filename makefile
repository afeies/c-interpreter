all: build/cint

build:
	mkdir -p build

build/lex.yy.c: clang.l | build
	flex -o build/lex.yy.c clang.l

build/expr.tab.c build/expr.tab.h: expr.y | build
	bison -d expr.y -o build/expr.tab.c

build/cint: build/lex.yy.c build/expr.tab.c build/expr.tab.h
	gcc -I build build/lex.yy.c build/expr.tab.c -o build/cint

clean:
	rm -rf build

test: build/cint
	./build/cint < factorial.c

.PHONY: all clean test
