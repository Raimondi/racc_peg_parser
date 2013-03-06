all: lib/peg/parser.rb

lib/peg/parser.rb: lib/peg/parser.racc
	racc -t -v -o lib/peg/parser.rb lib/peg/parser.racc

test: lib/peg/parser.rb
	./peg < rule.peg
	./peg < rule2.peg
	./peg < peg.peg
