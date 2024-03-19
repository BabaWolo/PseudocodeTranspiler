open Ast
  let rec eval_expr = function
  | Ecst(Cint(x)) -> x
  | Ebinop(binop, e1, e2) -> 
    let x = eval_expr e1 in
    let y = eval_expr e2 in
    match binop with
    | Badd -> x + y
    | Bsub -> x - y
    | Bdiv -> x / y
    | Bmul -> x * y
    | Bmod -> x mod y
    | Band -> if x = 1 && y = 1 then 1 else 0
    | Bor -> if x = 1 || y = 1 then 1 else 0
    | Beq -> if x = y then 1 else 0
    | Bneq -> if x != y then 1 else 0
    | Blt -> if x < y then 1 else 0
    | Ble -> if x <= y then 1 else 0
    | Bgt -> if x > y then 1 else 0
    | Bge -> if x >= y then 1 else 0
    
    
let () =
  let lexbuf = Lexing.from_string "(3 == 2) + 2 " in
  let ast = Parser.program Lexer.token lexbuf in
  print_endline ("Result: ");

  match ast with
  | Cexpr(e)  ->
    let result = eval_expr e in
    print_endline (string_of_int result) ;;
    print_endline ""
    


 (* Print tokens *)
 let print_token = function
  | Parser.EOF -> print_endline "EOF"
  | Parser.ADD -> print_endline "ADD"
  | Parser.INT x -> print_endline ("INT " ^ string_of_int x)
  | Parser.LPAREN -> print_endline "LPAREN"
  | Parser.RPAREN -> print_endline "RPAREN"
  | Parser.EQUAL -> print_endline "EQ"
  | Parser.SUB -> print_endline "SUB"
  | Parser.DIV -> print_endline "DIV"
  | Parser.MUL -> print_endline "MUL"
  | Parser.MOD -> print_endline "MOD"
  | Parser.AND -> print_endline "AND"
  | Parser.OR -> print_endline "OR"
  | Parser.GREATER -> print_endline "GREATER"
  | Parser.LESS -> print_endline "LESS"
  | Parser.GREATEREQUAL -> print_endline "GREATEREQUAL"
  | Parser.LESSEQUAL -> print_endline "LESSEQUAL"
  | Parser.NOTEQUAL -> print_endline "NOTEQUAL"



 let () =
   print_endline "Tokens:";
   let lexbuf = Lexing.from_string "(3 == 2) + 2" in
   let rec print_tokens () =
     let token = Lexer.token lexbuf in
     print_token token;
     match token with
     | Parser.EOF -> ()
     | _ -> print_tokens ()
   in
   print_tokens ()