open OUnit2
open Pseudo_lib.Ast
open Pseudo_lib.Python


(* tests *)
let test_position = {
  Lexing.pos_fname = "";
  Lexing.pos_lnum = 1;
  Lexing.pos_bol = 0;
  Lexing.pos_cnum = 4;
}, {
  Lexing.pos_fname = "";
  Lexing.pos_lnum = 1;
  Lexing.pos_bol = 0;
  Lexing.pos_cnum = 5;
}

let test_variable = { loc = test_position; id = "x"; typ = None }

(* assignment *)
let assignment_ast_input = Cstmt(Sassign(Eident(test_variable), Ecst(Cint 1, None), None))
let assignment_expected_output = "x = 1\n"

let test_assignment_codegen _ =
  assert_equal (generate_code assignment_ast_input) assignment_expected_output


(* return *)
let return_ast_input = Cstmt(Sreturn(Ecst(Cfloat 1.2, None)))
let return_expected_output = "return 1.2\n"

let test_return_codegen _ =
  assert_equal (generate_code return_ast_input) return_expected_output


(* if *)
let if_ast_input = Cstmt(Sif(
  Ebinop(Bneq, Ecst(Cint 1, None), Ecst(Cint 2, None), None),
  Sblock([Sprint(Ecst(Cint 1, None))]),
  Sblock([Sprint(Ecst(Cint 2, None))])
  ))
let if_expected_output = 
"if 1 != 2:\n  print(1)\nelse:\n  print(2)\n"

(* let test_if_codegen _ =
  assert_equal (generate_code if_ast_input) if_expected_output *)

(*Added debugging functions. Generates ASCII value for each character in the code and prints *)
let test_if_codegen _ =
  let generated_code = generate_code if_ast_input in
  let ascii_generated_code = generated_code |> String.to_seq |> List.of_seq |> List.map Char.code |> List.map string_of_int |> String.concat ", " in
  let ascii_expected_output = if_expected_output |> String.to_seq |> List.of_seq |> List.map Char.code |> List.map string_of_int |> String.concat ", " in
  print_endline ("ASCII values of generated code: " ^ ascii_generated_code);
  print_endline ("ASCII values of expected output: " ^ ascii_expected_output);
  assert_equal generated_code if_expected_output


(* for *)
let for_ast_input = Cstmt(Sfor(
  test_variable,
  Ecst(Cint 1, None),
  Ecst(Cint 10, None),
  Sblock[Seval(Ebinop(Badd, Eident(test_variable), Ecst(Cint 1, None), None))],
  1))
let for_expected_output = 
"for x in range(1, 10, 1):\n  x + 1\n"

let test_for_codegen _ =
  assert_equal (generate_code for_ast_input) for_expected_output

let suite =
  "Python Backend Suite" >::: [
      "test_assignment_code_generation" >:: test_assignment_codegen;
      "test_return_code_generation" >:: test_return_codegen;
      "test_if_code_generation" >:: test_if_codegen;
      "test_for_code_generation" >:: test_for_codegen;
    ]

