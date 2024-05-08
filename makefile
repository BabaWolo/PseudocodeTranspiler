all: build run test

init:
	@opam install . --deps-only --with-test

build:
	@dune build

test: 
	@dune runtest

build_test: build test

lang ?= python
run:
	@dune exec ./main.exe $(lang)

build_run: build run

build_run_test: build run test

.PHONY: clean
clean:
	@dune clean