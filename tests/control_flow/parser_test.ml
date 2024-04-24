open OUnit2
open Pseudo_lib.Ast

(* Function to parse an expression into an AST *)
let parse_expression expr =
  let lexbuf = Lexing.from_string expr in
  Pseudo_lib.Parser.program Pseudo_lib.Lexer.token lexbuf

(* Expected AST for "if (2 < 3) then 4 else 5" *)
let expected_ast = 
  Cstmt (Sif (Ebinop (Blt, Ecst (Cint 2), Ecst (Cint 3)), 
              Seval (Ecst (Cint 4)), 
              Seval (Ecst (Cint 5))))

(* OUnit test *)
let test_parse_expression _ =
  assert_equal (parse_expression 
  "if 2 < 3 {
    4 
  } else {
    5
  }") expected_ast

let suite =
  "Control Flow Parser Suite" >::: [
      "test_parse_control_flow_expression" >:: test_parse_expression;
    ]

(*
  This test checks if the AST generated by the function parse_expression for 
  the string "if (2 < 3) then 4 else 5" is equal to the expected AST. We utilize 
  both the parser and lexer to generate the AST. We should probably test the 
  parser and lexer separately, but for now, we will test them together. The AST 
  generated by parse_expression for "if (2 < 3) then 4 else 5" is equal to 
  expected_ast because it represents the correct control flow structure.
*)
