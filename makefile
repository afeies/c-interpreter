all: build/calc

build:
	mkdir -p build

build/lex.yy.c: calc.l | build
	flex -o build/lex.yy.c calc.l

build/calc: build/lex.yy.c
	gcc build/lex.yy.c -o build/calc

clean:
	rm -rf build

test: build/calc
	./build/calc < factorial.c

.PHONY: all clean test
