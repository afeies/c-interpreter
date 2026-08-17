CFLAGS = -I build -I .

HEADERS = ast.h interp.h parser.h
OBJS = build/lex.yy.o build/clang.tab.o build/ast.o build/interp.o build/main.o

all: build/cint

build:
	mkdir -p build

build/lex.yy.c: clang.l build/clang.tab.h | build
	flex -o build/lex.yy.c clang.l

build/clang.tab.c build/clang.tab.h: clang.y | build
	bison -d clang.y -o build/clang.tab.c

# Generated sources live in build/, hand-written ones in the project root.
build/%.o: build/%.c build/clang.tab.h $(HEADERS) | build
	gcc $(CFLAGS) -c $< -o $@

build/%.o: %.c build/clang.tab.h $(HEADERS) | build
	gcc $(CFLAGS) -c $< -o $@

build/cint: $(OBJS)
	gcc $(OBJS) -o build/cint

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
