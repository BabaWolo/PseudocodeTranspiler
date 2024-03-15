open Ast


let () =
  let lexbuf = Lexing.from_string "3+4" in
  let ast = Parser.program Lexer.token lexbuf in
  match ast with
  | Cexpr(Ebinop((Badd, Ecst(Cint(x)), Ecst(Cint(y)))))  ->
    let result = x + y in
    print_endline (string_of_int result)
  | _ ->
    print_endline "Unexpected expression"