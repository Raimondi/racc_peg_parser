require 'rubygems'
require 'lexr'

module Peg
  module Scanner
    def self.scan(source)
      tokens = []
      expr = Lexr.that {
        ident = /[a-zA-Z][a-zA-Z0-9]*/
        ignores /\s+/                   => :WHITE
        ignores /#.*$/                  => :COMM
        matches /\./                    => :DOT
        matches /\)/                    => :CLOSE
        matches /\(/                    => :OPEN
        matches /\+/                    => :PLUS
        matches /\*/                    => :STAR
        matches /\?/                    => :QUESTION
        matches /!/                     => :NOT
        matches /&/                     => :AND
        matches /\//                    => :SLASH
        matches /#{ident}\s*<-/         => :RULE
        matches /\[(\\.|[^\]])*\]/      => :CLASS
        matches /"(\\.|[^"])*"/         => :DQSTRING
        matches /'(\\.|[^'])*'/         => :SQSTRING
        matches ident                   => :IDENTIFIER
      }
      source.each_line {|line|
        lexer = expr.new(line)
        until lexer.end?
          token = lexer.next
          #puts token.inspect
          tokens << token unless token.value.nil?
        end
      }
      # wrap as [id, value] tokens for racc
      # trailing   end   token recast as   END   for racc
      tokens.map {|x| [x.type.upcase, x.value] } << [:END, nil]
    end
  end
end
