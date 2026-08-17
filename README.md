# c-interpreter
Simple C interpreter built from scratch for learning purposes

## Build

```bash
make
```

Requires `flex`, `bison`, and `gcc`. The binary is written to `build/cint`.

## Run

```bash
./build/cint              # read from stdin
./build/cint expr.c       # read from a file
make run-expr             # run the sample expression file
```

## Test

```bash
make test                 # run all tests
make test-verbose         # show output for each test
```

## Clean

```bash
make clean
```
