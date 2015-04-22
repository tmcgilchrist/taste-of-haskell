MFLAGS =
MAKEFLAGS = $(MFLAGS)
SANDBOX = .cabal-sandbox
CABAL_FLAGS =
DEPS = .cabal-sandbox/.cairn

.PHONY: build test repl repl-test quick tags reserve

default: build

${SANDBOX}:
	cabal sandbox init

${DEPS}: ${SANDBOX} $(wildcard *.cabal)
	cabal install -j --only-dependencies --enable-tests
	cabal configure --enable-tests ${CABAL_FLAGS}
	touch $@

build: ${DEPS}
	cabal build

test: ${DEPS}
	cabal test test --log=/dev/stdout

repl: ${DEPS}
	cabal repl

quick: ${DEPS}
	ghci -package-db=$(wildcard ${SANDBOX}/*-packages.conf.d) -isrc -itest src/Main.hs

tags:
	hasktags -e src test main
