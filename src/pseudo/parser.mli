
(* The type of tokens. *)

type token = 
  | WHILE
  | UNTIL
  | TO
  | SUB
  | RPAREN
  | RETURN
  | REPEAT
  | RBRACKET
  | RBRACE
  | PRINT
  | OR
  | NOTEQUAL
  | NEWLINE
  | NEW
  | MUL
  | MOD
  | LPAREN
  | LET
  | LESSEQUAL
  | LESS
  | LBRACKET
  | LBRACE
  | INT of (int)
  | IF
  | ID of (string)
  | GREATEREQUAL
  | GREATER
  | FOR
  | FLOAT of (float)
  | EQUAL
  | EOF
  | ELSE
  | DOWNTO
  | DOT
  | DO
  | DIV
  | CONTINUE
  | COMMA
  | BREAK
  | BE
  | ASSIGN
  | AND
  | ADD
  | A

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.command)
