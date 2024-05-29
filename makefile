all: build run test

init:
	@opam install . --deps-only --with-test

build:
	@opam exec -- dune build

test: 
	@opam exec -- dune runtest --force

build_test: build test

file ?= test.txt
lang ?= python
debug ?= false
run:
	@opam exec -- dune exec ./main.exe $(lang) $(file) $(debug)

build_run: build run

build_run_test: build run test

.PHONY: clean
clean:
	@dune clean