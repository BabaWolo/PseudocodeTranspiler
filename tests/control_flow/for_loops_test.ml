(* open OUnit2
open Pseudo_lib.Ast

(* Function to parse an expression into an AST *)
let parse_expression expr =
  let lexbuf = Lexing.from_string expr in
  Pseudo_lib.Parser.program Pseudo_lib.Lexer.token lexbuf

(* Expected AST for "if (2 < 3) then 4 else 5" *)
let expected_ast = 
  Cstmt (Sfor ({ loc = (Lexing.dummy_pos, Lexing.dummy_pos); id = "i" }, Ecst(Cint 1), Ecst(Cint 10), Sprint(Eident { loc = (Lexing.dummy_pos, Lexing.dummy_pos); id = "i" }), 1)) 

(* OUnit test *)
let test_parse_expression _ =
  assert_equal (parse_expression 
  "for i = 1 to 10 {
    print(i)
}") expected_ast

let suite =
  "Control Flow Parser Suite" >::: [
      "test_parse_control_flow_expression" >:: test_parse_expression;
    ]
 *)