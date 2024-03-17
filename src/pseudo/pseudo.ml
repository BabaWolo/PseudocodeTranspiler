open Ast

(* 
(* Print tokens *)
let print_token = function
  | Parser.EOF -> print_endline "EOF"
  | Parser.PLUS -> print_endline "PLUS"
  | Parser.INT x -> print_endline ("INT " ^ string_of_int x)

let () =
  let lexbuf = Lexing.from_string "3+4" in
  let rec print_tokens () =
    let token = Lexer.token lexbuf in
    print_token token;
    match token with
    | Parser.EOF -> ()
    | _ -> print_tokens ()
  in
  print_tokens () *)

let () =
  let lexbuf = Lexing.from_string "3+4" in
  let ast = Parser.program Lexer.token lexbuf in

  match ast with
  | Cexpr(Ebinop((Badd, Cint(x), Cint(y))))  ->
    let result = x + y in
    print_endline (string_of_int result)
(*   | _ ->
    print_endline "Unexpected expression" *)