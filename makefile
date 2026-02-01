all: build/cint

build:
	mkdir -p build

build/lex.yy.c: clang.l | build
	flex -o build/lex.yy.c clang.l

build/clang.tab.c build/clang.tab.h: clang.y | build
	bison -d clang.y -o build/clang.tab.c

build/cint: build/lex.yy.c build/clang.tab.c build/clang.tab.h
	gcc -I build build/lex.yy.c build/clang.tab.c -o build/cint

clean:
	rm -rf build

test: build/cint
	./build/cint < factorial.c

.PHONY: all clean test
