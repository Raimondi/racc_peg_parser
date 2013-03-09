#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lib/peg/scanner.rex".
#++

require 'racc/parser'
module Peg
class Parser < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/\./))
         action { [:DOT, text] }

      when (text = @ss.scan(/\)/))
         action { [:CLOSE, text] }

      when (text = @ss.scan(/\(/))
         action { [:OPEN, text] }

      when (text = @ss.scan(/\+/))
         action { [:PLUS, text] }

      when (text = @ss.scan(/\*/))
         action { [:STAR, text] }

      when (text = @ss.scan(/\?/))
         action { [:QUESTION, text] }

      when (text = @ss.scan(/!/))
         action { [:NOT, text] }

      when (text = @ss.scan(/&/))
         action { [:AND, text] }

      when (text = @ss.scan(/\//))
         action { [:SLASH, text] }

      when (text = @ss.scan(/[a-zA-Z][a-zA-Z0-9]*\s*<-/))
         action { [:RULE, text] }

      when (text = @ss.scan(/\#.*$/))
        ;

      when (text = @ss.scan(/\[/))
         action { @state = :CC; [:STARTSCC, text] }

      when (text = @ss.scan(/"(\\.|[^"])*"/))
         action { [:DQSTRING, text] }

      when (text = @ss.scan(/'(\\.|[^'])*'/))
         action { [:SQSTRING, text] }

      when (text = @ss.scan(/[a-zA-Z][a-zA-Z0-9]*/))
         action { [:IDENTIFIER, text] }

      when (text = @ss.scan(/\d/))
         action { [:NUMBER, text] }

      when (text = @ss.scan(/\s+/))
        ;

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    when :CC
      case
      when (text = @ss.scan(/\]/))
         action { @state = nil; [:ENDSCC, text] }

      when (text = @ss.scan(/\\[nrt'"\[\]\\]/))
         action { [:CCESCAPED, text] }

      when (text = @ss.scan(/\\([0-2]?[0-7])?[0-7]/))
         action { [:CCOCTAL, text] }

      when (text = @ss.scan(/./))
         action { [:CCCHAR, text] }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    p token
    token
  end  # def _next_token

end # class
end
