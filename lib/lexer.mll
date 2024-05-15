(* Lexer is a program that takes a sequence of characters and breaks it down into tokens that can be processed by a parser. *)
{
  open Parser
}

(* Patterns to define tokens by rocognizing numbers, identifiers, etc. *)
let digit = ['0'-'9']
let float = digit+'.'digit+
let integer = '0' | ['1'-'9'] digit*
let space = ' ' | '\t' | '\r' 
let letter = ['a'-'z' 'A'-'Z']
let ident = (letter | '_') (letter | digit | '_')*
let any_char = [^'"'] (* [^ ] denotes a negated character class, meaning it matches any character not listed within the square brackets. *)
let string = '"' any_char* '"'
let comment = "//" [^'\n']* ('\n' | eof)

(* Lexer rule named 'ident' to tokenize an input stream into a series of tokens. *)

(* Lexer rule named 'token' to tokenize an input stream into a series of tokens. *)
rule token = parse
  | "\n"    { Lexing.new_line lexbuf; NEWLINE} 
  | space { token lexbuf }
  | comment { COMMENT(Lexing.lexeme lexbuf) }
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
  | "elseif" { ELSEIF}
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
  | "exchange" { EXCHANGE }
  | "with" { WITH }
  | "random" { RANDOM }
  | "NIL" { NIL }
  | "infinity" { INFINITY }
  | "error" { ERROR }
  | digit+  { INT(int_of_string (Lexing.lexeme lexbuf)) } (* lexbuf contains the current state of the lexer, including current position in input stream and matched string. *)
  | float+  { FLOAT(float_of_string (Lexing.lexeme lexbuf)) }
  | ident   { ID(Lexing.lexeme lexbuf) }
  | string  { STRING(Lexing.lexeme lexbuf) }
  | eof     { EOF }  
  | _ as c  { raise (Failure ("illegal character: " ^ Char.escaped c)) }
