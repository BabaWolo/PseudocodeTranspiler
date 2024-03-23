open Ast
module StringMap = Map.Make(String)
  
  (* Convert to python *)
  let string_of_ident ident = ident.id

  let functions = (Hashtbl.create 16 : (string, expr list * stmt) Hashtbl.t)

  let rec string_of_expr = function
  | Eident(id) -> string_of_ident id
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
    | Sassign(id, e) -> 
      String.make indent ' ' ^ string_of_ident id ^ " = " ^ string_of_expr e ^ "\n"
    | Sif(e, stmt, Sblock []) ->
      String.make indent ' ' ^ "if " ^ string_of_expr e ^ ":\n" ^ string_of_stmt (indent+2) stmt
    | Sif(e, stmt, else_stmts) ->
      String.make indent ' ' ^ "if " ^ string_of_expr e ^ ":\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "else:\n" ^ string_of_stmt (indent+2) else_stmts
    | Seval(e) ->
      String.make indent ' ' ^ string_of_expr e ^ "\n"
    | Sprint(e) ->
      String.make indent ' ' ^ "print(" ^ string_of_expr e ^ ")\n"
    | Sreturn(e) ->
      String.make indent ' ' ^ "return " ^ string_of_expr e ^ "\n"
    | Sblock(stmts) ->
      "\n" ^ (String.concat "" (List.map (string_of_stmt (indent)) stmts))
    | Sdef(id, args, stmt) ->
      Hashtbl.add functions (string_of_ident id) (args, stmt);
      String.make indent ' ' ^ string_of_ident id ^ "(" ^ (String.concat ", " (List.map string_of_expr args)) ^ ")" ^ "\n" ^ string_of_stmt (indent+2) stmt
    | Scall(id, args) ->
      if Hashtbl.mem functions (string_of_ident id) then
        String.make indent ' ' ^ string_of_ident id ^ "(" ^ (String.concat ", " (List.map string_of_expr args)) ^ ")" ^ "\n"
      else
        failwith (string_of_ident id ^ " is not defined")


  let string_of_program = function
    | Cstmt(stmt) -> string_of_stmt 0 stmt

    
let () =
  let lexbuf = Lexing.from_string "a=1\n b=2\n function(a,b){a+b} \n fun(2, 2+2){1} \n fun(2*2) \n x = 2 \n if(1 < 2 < 3){ x = x+1 \n y = x \n}\n  PRINT(x) \n PRINT(y)" in
  let ast = Parser.program Lexer.token lexbuf in
  let out_channel = open_out "output.py" in
  match ast with
  | Cstmt(stmt) ->
    Printf.fprintf out_channel "%s\n" (string_of_program (Cstmt(stmt)));
  close_out out_channel
