open Ast
module StringMap = Map.Make(String)
  
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
  let lexbuf = Lexing.from_string "x = 2 \n if(1 < 2 < 3){ x = x+1 \n }\n PRINT(x)" in
  let ast = Parser.program Lexer.token lexbuf in
  let out_channel = open_out "output.py" in
  match ast with
  | Cstmts(_) ->
    Printf.fprintf out_channel "%s\n" (string_of_program ast);
  close_out out_channel
