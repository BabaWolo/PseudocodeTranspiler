open OUnit2
open Pseudo_lib.Parser

let string_of_token = function
  | FOR -> "FOR"
  | ID s -> "ID " ^ s
  | EQUAL -> "EQUAL"
  | INT i -> "INT " ^ string_of_int i
  | TO -> "TO"
  | LBRACE -> "LBRACE"
  | PRINT -> "PRINT"
  | LPAREN -> "LPAREN"
  | STRING s -> "STRING " ^ s 
  | RPAREN -> "RPAREN"
  | RBRACE -> "RBRACE"
  | EOF -> "EOF"
  | WITH -> "WITH"
  | WHILE -> "WHILE"
  | UNTIL -> "UNTIL"
  | SUB -> "SUB"
  | SORT -> "SORT"
  | RETURN -> "RETURN"
  | REPEAT -> "REPEAT"
  | RBRACKET -> "RBRACKET"
  | RANDOM -> "RANDOM"
  | OR -> "OR"
  | NOTEQUAL -> "NOTEQUAL"
  | NIL -> "NIL"
  | NEWLINE -> "NEWLINE"
  | NEW -> "NEW"
  | MUL -> "MUL"
  | MOD -> "MOD"
  | LET -> "LET"
  | LESSEQUAL -> "LESSEQUAL"
  | LESS -> "LESS"
  | LBRACKET -> "LBRACKET"
  | IF -> "IF"
  | GREATEREQUAL -> "GREATEREQUAL"
  | GREATER -> "GREATER"
  | EXCHANGE -> "EXCHANGE"
  | ELSE -> "ELSE"
  | DOWNTO -> "DOWNTO"
  | DOT -> "DOT"
  | DO -> "DO"
  | DIV -> "DIV"
  | CONTINUE -> "CONTINUE"
  | COMMA -> "COMMA"
  | BREAK -> "BREAK"
  | BE -> "BE"
  | ASSIGN -> "ASSIGN"
  | AND -> "AND"
  | ADD -> "ADD"
  | A -> "A"
  | FLOAT f -> "FLOAT " ^ string_of_float f
  | COMMENT s -> "COMMENT " ^ s

let string_of_token_list tokens =
  tokens |> List.map string_of_token |> String.concat "; "

let test_lexer _ =
  let lexbuf = Lexing.from_string "let i be 10
  for i = 1 to 10 {
    print(\"hello\")
    if i == 5 {
      break
    } else {
      continue
    }
  }
  while i < 20 {
    print(\"hello\")
    i = i + 1
  }
  repeat {
    print(\"hello\")
    i = i - 1
  } until i == 0
  do {
    print(\"hello\")
    i = i * 2
  } while i <= 40
  let test be new [1, 2, 3]
  test2.sort
  test3.exchange 1 with 2
  let randomNum be random
  NIL" in
  let rec get_all_tokens acc =
    let token = Pseudo_lib.Lexer.token lexbuf in
    let acc = token :: acc in
    if token = EOF then
      List.rev acc
    else
      get_all_tokens acc
  in
  let tokens = get_all_tokens [] in

  (*Weird Ocaml thing with concatanation and quote symbols, so had to declare the string in order for the quotes to be equal in the test *)
  let string_hello = "\"hello\"" in
  let expected_tokens = [
    LET; ID "i"; BE; INT 10; NEWLINE;
    FOR; ID "i"; ASSIGN; INT 1; TO; INT 10; LBRACE; NEWLINE;
      PRINT; LPAREN; STRING string_hello; RPAREN; NEWLINE;
      IF; ID "i"; EQUAL; INT 5; LBRACE; NEWLINE;
        BREAK; NEWLINE;
      RBRACE; ELSE; LBRACE; NEWLINE;
        CONTINUE; NEWLINE;
      RBRACE; NEWLINE;
    RBRACE; NEWLINE;
    WHILE; ID "i"; LESS; INT 20; LBRACE; NEWLINE;
      PRINT; LPAREN; STRING string_hello; RPAREN; NEWLINE;
      ID "i"; ASSIGN; ID "i"; ADD; INT 1; NEWLINE;
    RBRACE; NEWLINE;
    REPEAT; LBRACE; NEWLINE;
      PRINT; LPAREN; STRING string_hello; RPAREN; NEWLINE;
      ID "i"; ASSIGN; ID "i"; SUB; INT 1; NEWLINE; RBRACE;
    UNTIL; ID "i"; EQUAL; INT 0; NEWLINE;
    DO; LBRACE; NEWLINE;
      PRINT; LPAREN; STRING string_hello; RPAREN; NEWLINE;
      ID "i"; ASSIGN; ID "i"; MUL; INT 2; NEWLINE; RBRACE;
    WHILE; ID "i"; LESSEQUAL; INT 40; NEWLINE;
    LET; ID "test"; BE; NEW; LBRACKET; INT 1; COMMA; INT 2; COMMA; INT 3; RBRACKET; NEWLINE;
    ID "test2"; DOT; SORT; NEWLINE;
    ID "test3"; DOT; EXCHANGE; INT 1; WITH; INT 2; NEWLINE;
    LET; ID "randomNum"; BE; RANDOM; NEWLINE;
    NIL; 
    EOF
  ] in
  assert_equal ~printer:string_of_token_list tokens expected_tokens
let suite =
  "Lexer Test Suite" >::: [
    "test_lexer" >:: test_lexer;
  ]
