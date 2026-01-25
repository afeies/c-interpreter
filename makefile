all: build/cint

build:
	mkdir -p build

build/lex.yy.c: clang.l | build
	flex -o build/lex.yy.c clang.l

build/cint: build/lex.yy.c
	gcc build/lex.yy.c -o build/cint

clean:
	rm -rf build

test: build/cint
	./build/cint < factorial.c

.PHONY: all clean test
