all: lib/peg/parser.rb

lib/peg/parser.rb: lib/peg/parser.racc
	racc -t -v -o lib/peg/parser.rb lib/peg/parser.racc

