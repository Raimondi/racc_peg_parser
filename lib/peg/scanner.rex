module Peg
class Parser
macro
  IDENT [a-zA-Z][a-zA-Z0-9]*
rule
  \.               { [:DOT, text] }
  \)               { [:CLOSE, text] }
  \(               { [:OPEN, text] }
  \+               { [:PLUS, text] }
  \*               { [:STAR, text] }
  \?               { [:QUESTION, text] }
  !                { [:NOT, text] }
  &                { [:AND, text] }
  \/               { [:SLASH, text] }
  {IDENT}\s*<-    { [:RULE, text] }
  \#.*$
  \[               { @state = :CC; [:STARTSCC, text] }
  :CC \]           { @state = nil; [:ENDSCC, text] }
  :CC \\[nrt'"\[\]\\] { [:CCESCAPED, text] }
  :CC \\([0-2]?[0-7])?[0-7] { [:CCOCTAL, text] }
  :CC .            { [:CCCHAR, text] }
  "(\\.|[^"])*"    { [:DQSTRING, text] }
  '(\\.|[^'])*'    { [:SQSTRING, text] }
  {IDENT}         { [:IDENTIFIER, text] }
  \d               { [:NUMBER, text] }
  \s+
inner
end
end
