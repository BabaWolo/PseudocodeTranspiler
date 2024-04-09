{
  open Parser
}

let digit = ['0'-'9']
let float = digit+'.'digit+
let integer = '0' | ['1'-'9'] digit*
let space = ' ' | '\t'
let letter = ['a'-'z' 'A'-'Z']
let ident = (letter | '_') (letter | digit | '_')*

rule token = parse
  | "\n"    { Lexing.new_line lexbuf; NEWLINE} 
  | space { token lexbuf }
  | '+'     { ADD }
  | '-'     { SUB }
  | '*'     { MUL }
  | '/'     { DIV }
  | '%'     { MOD }
  | '('     { LPAREN }
  | ')'     { RPAREN }
  | '['     { LBRACKET }
  | ']'     { RBRACKET }
  | "and"   { AND }
  | "or"    { OR }
  | "=="    { EQUAL }
  | "!="    { NOTEQUAL }
  | "<"     { LESS }
  | "<="    { LESSEQUAL }
  | ">"     { GREATER }
  | ">="    { GREATEREQUAL }
  | '='     { ASSIGN }
  | "if"    { IF }
  | "else"  { ELSE }
  | '{'     { LBRACE }
  | '}'     { RBRACE }
  | ','     { COMMA }
  | "print" { PRINT }
  | "return" { RETURN } 
  | "for"   { FOR }
  | "while" { WHILE }
  | "break" { BREAK }
  | "continue" { CONTINUE }
  | "repeat"    { REPEAT }
  | "until"     { UNTIL }
  | "do"    { DO }
  | "to"    { TO }
  | "downto" { DOWNTO }
  | "let"   { LET }
  | "be"    { BE }
  | "a"     { A }
  | "new"   { NEW }
  | "."     { DOT }
  | "sort"  { SORT }
  | "error" { ERROR }
  | '"'     { STRING (string lexbuf) }
  | digit+  { INT(int_of_string (Lexing.lexeme lexbuf)) }
  | float+  { FLOAT(float_of_string (Lexing.lexeme lexbuf)) }
  | ident   { ID(Lexing.lexeme lexbuf) }
  | eof     { EOF }  
  | _ as c  { raise (Failure ("illegal character: " ^ Char.escaped c)) }

and string = parse
  | '"'     { "" }
  | '\\'    { escaped lexbuf }
  | _       { Lexing.lexeme lexbuf ^ string lexbuf }

and escaped = parse
  | 'n'     { "\n" ^ string lexbuf }
  | 't'     { "\t" ^ string lexbuf }
  | '"'     { "\"" ^ string lexbuf }
  | _       { raise (Failure "illegal escape sequence") }