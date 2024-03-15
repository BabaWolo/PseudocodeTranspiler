open Lexing


type comparison = Beq | Bneq | Blt | Ble | Bgt | Bge

type token =
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | EQUAL
  | CMP of comparison
  | MOD
  | LP
  | RP
  | LSQ
  | RSQ
  | COMMA
  | COLON
  | NEWLINE
  | ID of string
  | INT of int
  | EOF


let string_of_token = function
  | PLUS -> "PLUS"
  | MINUS -> "MINUS"
  | TIMES -> "TIMES"
  | DIV -> "DIV"
  | EQUAL -> "EQUAL"
  | CMP c -> "CMP " ^ (match c with
                       | Beq -> "Beq"
                       | Bneq -> "Bneq"
                       | Blt -> "Blt"
                       | Ble -> "Ble"
                       | Bgt -> "Bgt"
                       | Bge -> "Bge")
  | MOD -> "MOD"
  | LP -> "LP"
  | RP -> "RP"
  | LSQ -> "LSQ"
  | RSQ -> "RSQ"
  | COMMA -> "COMMA"
  | COLON -> "COLON"
  | NEWLINE -> "NEWLINE"
  | ID id -> "ID " ^ id
  | INT num -> "INT " ^ string_of_int num
  | EOF -> "EOF"

let lex_test filename =
  print_endline ("Lexing " ^ filename);
  let input_channel = 
    try open_in filename 
    with Sys_error err -> 
      print_endline ("Cannot open file: " ^ err); 
      exit 1 
  in
  let lexbuf = Lexing.from_channel input_channel in
  let rec loop () =
    match Lexer.token lexbuf with
     | token :: _ ->
        print_endline (string_of_token token);
        loop ()
     | [] -> ()
  in
  loop ()

let () =
  let filename = "test.txt" in
  lex_test filename



  
