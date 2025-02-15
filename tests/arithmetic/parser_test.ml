open OUnit2
open Pseudo_lib.Ast

(* Function to parse an expression into an AST *)
let parse_expression expr =
  let lexbuf = Lexing.from_string expr in
  Pseudo_lib.Parser.program Pseudo_lib.Lexer.token lexbuf

(* Expected AST for "2 + 3" *)
let expected_ast = Cstmt (Seval (Ebinop (Badd, Ecst (Cint 2, None), Ecst (Cint 3, None), None)))

(* OUnit test *)
let test_parse_expression _ =
  assert_equal (parse_expression "2 + 3") expected_ast

let suite =
  "Arithmetic Parser Suite" >::: [
      "test_parse_arithmetic_expression" >:: test_parse_expression;
    ]


(*
  This test checks if the  AST generated by the function parse_expression for 
  the string "2 + 3" is equal to the expected AST. We utilize both the parser 
  and lexer to generate the AST. We should probably test the parser and lexer 
  separately, but for now,  we will test them together.  The AST generated by 
  parse_expression for "2 + 3" is equal to expected_ast because it represents 
  the program  "evaluate the expression '2 + 3'", corresponding to the string 
  "2 + 3" in  this  context.
*)
