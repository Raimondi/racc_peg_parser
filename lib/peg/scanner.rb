require 'rubygems'
require 'lexr'

module Peg
  module Scanner
    def self.scan(source)
      tokens = []
      expr = Lexr.that {
        matches /\s+/        => :WHITESPACE
      }
      lexer = expr.new(source)
      until lexer.end?
        tokens << lexer.next
      end
      # wrap as [id, value] tokens for racc
      # trailing   end   token recast as   END   for racc
      tokens.map {|x| [x.type.upcase, x.value] }
    end
  end
end
