open OUnit2
open Pseudo_lib
open Ast

let generate_code target_language = function
  | Cstmt(_) as ast ->
    match target_language with
    | "python" -> Python.generate_code ast
    | "java" -> Java.generate_code ast
    (* Add more cases for other languages here *)
    | _ -> failwith "Unsupported target language"

let get_in_channel file_name =
  let file = Filename.concat (Sys.getcwd () ^ "/acceptance/") file_name in
  open_in file


let compile_to_output target_language =
  let in_channel = get_in_channel "test_input.pseudo" in
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
      Printf.eprintf 
      "***ACCEPTANCE TEST***\nSyntax error at line %d, column %d, token %s\n***ACCEPTANCE TEST***\n" line cnum tok;
      close_in in_channel;
      exit (-1)
  in
  close_in in_channel;
  generate_code target_language ast


let expected_python_output () =
  let in_channel = get_in_channel "test_expected_python.py" in
  let res = really_input_string in_channel (in_channel_length in_channel) in
  close_in in_channel;
  res


let python_acceptance_test _ = 
  let python_output = compile_to_output "python" in
  let expected_python_output = expected_python_output () in
  assert_equal expected_python_output python_output


let suite =
  "Acceptance Suite" >::: [
      "acceptance_python" >:: python_acceptance_test;
    ]