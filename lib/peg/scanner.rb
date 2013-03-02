require 'rubygems'
require 'lexr'

module Peg
  module Scanner
    def self.scan(source)
      tokens = []
      expr = Lexr.that {
        matches /[ \t]+/                   => :WHITE
        matches /\r\n|\n|\r/            => :EOL
        #matches /#/                     => :HASH
        matches /\./                    => :POINT
        matches /\)/                    => :CLOSE_PAREN
        matches /\(/                    => :OPEN_PAREN
        matches /\+/                    => :PLUS
        matches /\*/                    => :STAR
        matches /\?/                    => :INTERR
        matches /!/                     => :EXCLAMATION
        matches /&/                     => :AMPER
        matches /\//                    => :SL
        matches /<-/                    => :ARROW
        matches /#.*$/                  => :COMM
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
      file = File.open(source)
      file.each {|line|
        lexer = expr.new(line)
        until lexer.end?
          token = lexer.next
          #puts token.inspect
          tokens << token unless token.value.nil?
        end
      }
      tokens << token
      # wrap as [id, value] tokens for racc
      # trailing   end   token recast as   END   for racc
      tokens.map {|x| [x.type.upcase, x.value] }
    end
  end
end
