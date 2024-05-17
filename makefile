all: build run test

init:
	@opam install . --deps-only --with-test

build:
	@opam exec -- dune build

test: 
	@opam exec -- dune runtest

build_test: build test

file ?= test.txt
lang ?= python
run:
	@opam exec -- dune exec ./main.exe $(lang) $(file)

build_run: build run

build_run_test: build run test

.PHONY: clean
clean:
	@dune clean