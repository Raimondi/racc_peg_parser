.PHONY: all test
all: lib/peg/parser.rb lib/peg/scanner.rb

lib/peg/scanner.rb: lib/peg/scanner.rex
	rex -d -o lib/peg/scanner.rb lib/peg/scanner.rex

lib/peg/parser.rb: lib/peg/parser.racc
	racc -t -v -o lib/peg/parser.rb lib/peg/parser.racc

test: all
	./peg < rule.peg
	./peg < rule2.peg
	./peg < peg.peg
