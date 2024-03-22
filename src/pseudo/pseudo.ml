open Ast
module StringMap = Map.Make(String)
  (* let rec eval_expr env = function
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
  | Sif(e, stmts) ::
    tl -> 
    let x = eval_expr env e in
    if x = 1 then
      eval_stmt env stmts
    else
      eval_stmt env tl
  | Seval(e) :: tl -> 
    let x = eval_expr env e in
    match tl with
    | [] -> x
    | _ -> eval_stmt env tl
    
    
    
let () =
  let lexbuf = Lexing.from_string "x = 1 \n if(2==2){ x = 2 \n }\n x+2" in
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
  | Parser.LBRACE -> print_endline "LBRACE"
  | Parser.RBRACE -> print_endline "RBRACE"
  | Parser.IF -> print_endline "IF"



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
   print_tokens () *)

  (* Convert to python *)
  let rec string_of_expr = function
  | Eident(id) -> id
  | Ecst(Cint(x)) -> string_of_int x
  | Ebinop(binop, e1, e2) -> 
    let x = string_of_expr e1 in
    let y = string_of_expr e2 in
    match binop with
    | Badd -> x ^ " + " ^ y
    | Bsub -> x ^ " - " ^ y
    | Bdiv -> x ^ " / " ^ y
    | Bmul -> x ^ " * " ^ y
    | Bmod -> x ^ " % " ^ y
    | Band -> x ^ " and " ^ y
    | Bor -> x ^ " or " ^ y
    | Beq -> x ^ " == " ^ y
    | Bneq -> x ^ " != " ^ y
    | Blt -> x ^ " < " ^ y
    | Ble -> x ^ " <= " ^ y
    | Bgt -> x ^ " > " ^ y
    | Bge -> x ^ " >= " ^ y

  let rec string_of_stmt indent = function
  | [] -> ""
  | Sassign(id, e) :: tl -> 
    String.make indent ' ' ^ id ^ " = " ^ string_of_expr e ^ "\n" ^ string_of_stmt indent tl
  | Sif(e, stmts) :: tl ->
    String.make indent ' ' ^ "if " ^ string_of_expr e ^ ":\n" ^ string_of_stmt (indent + 2) stmts ^ string_of_stmt indent tl
  | Seval(e) :: tl ->
    String.make indent ' ' ^ string_of_expr e ^ "\n" ^ string_of_stmt indent tl
  | Sprint(e) :: tl ->
    String.make indent ' ' ^ "print(" ^ string_of_expr e ^ ")\n" ^ string_of_stmt indent tl

let string_of_program = function
  | Cstmts(stmt) -> string_of_stmt 0 stmt
    
let () =
  let lexbuf = Lexing.from_string "x = 2 \n if(x % 2 == 0){ x = x + 1 \n x = x / 2 \n }\n PRINT(x)" in
  let ast = Parser.program Lexer.token lexbuf in
  let out_channel = open_out "output.py" in
  match ast with
  | Cstmts(_) ->
    Printf.fprintf out_channel "%s\n" (string_of_program ast);
  close_out out_channel
