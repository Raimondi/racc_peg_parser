require 'rubygems'
require 'lexr'

module Peg
  module Scanner
    def self.scan(source)
      tokens = []
      expr = Lexr.that {
        matches /\r\n|\n|\r/            => :EOL
        ignores /\s+/ => :WHITE
        #matches /[ \t]+/                   => :WHITE
        #matches /#/                     => :HASH
        matches /\./                    => :DOT
        matches /\)/                    => :CLOSE
        matches /\(/                    => :OPEN
        matches /\+/                    => :PLUS
        matches /\*/                    => :STAR
        matches /\?/                    => :QUESTION
        matches /!/                     => :NOT
        matches /&/                     => :AND
        matches /\//                    => :SLASH
        matches /<-/                    => :LEFTARROW
        ignores /#.*$/                  => :COMM
        #matches /(?<!\\)./              => :NON_ESC
        #matches /\\[nrt'"\[\]\\]/       => :ESC
        #matches /\\([0-2]?[0-7])?[0-7]/ => :OCT
        #matches /-/                     => :DASH
        #matches /\[/                    => :OPEN_SQ
        #matches /\]/                    => :CLOSE_SQ
        #matches /'/                     => :SQUOTE
        #matches /"/                     => :DQUOTE
        matches /\[(\\.|[^\]])*\]/      => :CLASS
        matches /"(\\.|[^"])*"/         => :DQSTRING
        matches /'(\\.|[^'])*'/         => :SQSTRING
        matches /\d/                    => :NUMBER
        matches /[a-zA-Z]+/             => :IDENTSTART

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
