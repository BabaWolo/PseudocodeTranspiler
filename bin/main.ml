open Pseudo_lib
open Ast

let generate_code target_language = function
  | Cstmt(_) as ast ->
    match target_language with
    | "python" -> Python.generate_code ast
    (* Add more cases for other languages here *)
    | _ -> failwith "Unsupported target language"

(* Main function for reading in the file and writing to a new file *)
let () =
  (* Checks if command-line argument has been provided before accessing *)
  if Array.length Sys.argv < 2 then begin
    Printf.eprintf "Error: No target language provided\n";
    exit 1
  end;
  let target_language = Sys.argv.(1) in
  let in_channel = open_in "../lib/test.txt" in
  let lexbuf = Lexing.from_channel in_channel in
  let ast = 
    try
      Parser.program Lexer.token lexbuf
    with
    | Parser.Error ->
      let curr = lexbuf.Lexing.lex_curr_p in
      let line = curr.Lexing.pos_lnum in
      let cnum = curr.Lexing.pos_cnum - curr.Lexing.pos_bol in
      let tok = Lexing.lexeme lexbuf in
      Printf.eprintf "Syntax error at line %d, column %d, token %s\n" line cnum tok;
      exit (-1) 
  in
  let out_channel = open_out "../output.py" in
  let code = generate_code target_language ast in
  Printf.fprintf out_channel "%s\n" code;
  close_out out_channel;
  close_in in_channel