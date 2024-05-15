open OUnit2
open Pseudo_lib.Ast
open Pseudo_lib.Python

(* Function to parse an expression into an AST *)
let parse_expression expr =
  let lexbuf = Lexing.from_string expr in
  Pseudo_lib.Parser.program Pseudo_lib.Lexer.token lexbuf


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

let test_variable = { loc = test_position; id = "x"}

(* assignment *)
let assignment_ast_input = Sassign(Eident(test_variable), Ecst(Cint 1))
let assignment_expected_output = "x = 1\n"

let test_assignment_codegen _ =
  assert_equal (generate_code assignment_ast_input) assignment_expected_output


(* return *)
let return_ast_input = Sreturn(Ecst(Cfloat 1.2))
let return_expected_output = "return 1.2\n"

let test_return_codegen _ =
  assert_equal (generate_code return_ast_input) return_expected_output


(* if *)
let if_ast_input = Sif(
  Ebinop(Bneq, Ecst(Cint 1), Ecst(Cint 2)),
  Sblock([Sprint(Ecst(Cint 1))]),
  Sblock([Sprint(Ecst(Cint 2))])
  )
let if_expected_output = 
"if 1 != 2:
  print(1)
else:
  print(2)\n"

let test_if_codegen _ =
  assert_equal (generate_code if_ast_input) if_expected_output


(* for *)
let for_ast_input = Sfor(
  test_variable,
  Ecst(Cint 1),
  Ecst(Cint 10),
  Sblock[Seval(Ebinop(Badd, Eident(test_variable), Ecst(Cint 1)))],
  1)
let for_expected_output = 
"for x in range(1, 10, 1):
  x + 1\n"

let test_for_codegen _ =
  assert_equal (generate_code for_ast_input) for_expected_output

let suite =
  "Python Backend Suite" >::: [
      "test_assignment_code_generation" >:: test_assignment_codegen;
      "test_return_code_generation" >:: test_return_codegen;
      "test_if_code_generation" >:: test_if_codegen;
      "test_for_code_generation" >:: test_for_codegen;
    ]

