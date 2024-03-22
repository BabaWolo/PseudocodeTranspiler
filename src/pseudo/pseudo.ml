open Ast
module StringMap = Map.Make(String)
  let rec eval_expr env = function
  | Eident(id) ->
    begin try
      StringMap.find id !env
    with Not_found ->
      failwith ("Unbound identifier " ^ id)
    end
  | Ecst(Cint(x)) -> x
  | Ebinop(binop, e1, e2) -> 
    let x = eval_expr env e1 in
    let y = eval_expr env e2 in
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
    
  let rec eval_stmt env = function
  | [] -> 0 (* or whatever default value you want *)
  | Sassign(id, e) :: tl -> 
    let x = eval_expr env e in
    env := StringMap.add id x !env;
    eval_stmt env tl
  | Seval(e) :: tl -> 
    let x = eval_expr env e in
    match tl with
    | [] -> x
    | _ -> eval_stmt env tl
    
    
    
let () =
  let lexbuf = Lexing.from_string "x = 2 + 2 \n x " in
  let ast = Parser.program Lexer.token lexbuf in
  print_endline ("Result: ");
  
  let env = ref StringMap.empty in
  match ast with
  | Cstmts(stmt) ->
    let result = eval_stmt env stmt in
    print_endline (string_of_int result)



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
  | Parser.ID x -> print_endline ("ID " ^ x)
  | Parser.ASSIGN -> print_endline "ASSIGN"
  | Parser.NEWLINE -> print_endline "NEWLINE"



 let () =
   print_endline "Tokens:";
   let lexbuf = Lexing.from_string "x = 2 \n x + 4" in
   let rec print_tokens () =
     let token = Lexer.token lexbuf in
     print_token token;
     match token with
     | Parser.EOF -> ()
     | _ -> print_tokens ()
   in
   print_tokens ()