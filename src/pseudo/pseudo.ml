open Ast
module StringMap = Map.Make(String)
  
  (* Convert to python *)
  let string_of_ident ident = ident.id

  let functions = (Hashtbl.create 16 : (string, ident list * stmt) Hashtbl.t)

  let rec string_of_expr = function
  | Eident(id) -> string_of_ident id
  | Ecst(x) ->
    begin
      match x with
      | Cint(i) -> string_of_int i
      | Cfloat(f) -> string_of_float f
    end
  | Emethod(id, method_name) ->
    let method_name = string_of_ident method_name in
    begin
      match method_name with
      | "length" -> "len(" ^ string_of_ident id ^ ")"
      | _ -> failwith "Method not supported"
    end
  | Elist(expr_list) ->
    "[" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ "]"
  | Eget(id, index) ->
    string_of_ident id ^ "[" ^ string_of_expr index ^ "]"
  | Ecall(id, args) -> 
    string_of_ident id ^ "(" ^ (String.concat ", " (List.map string_of_expr args)) ^ ")"
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
      String.concat "" (List.map (string_of_stmt (indent)) stmts)
    | Sdef(id, args, stmt) ->
      Hashtbl.add functions (string_of_ident id) (args, stmt);
      String.make indent ' ' ^ "def " ^ string_of_ident id ^ "(" ^ (String.concat ", " (List.map string_of_ident args)) ^ ")" ^ ":\n" ^ string_of_stmt (indent+2) stmt
    | Sfor(id, e1, e2, stmt, incr) ->
      String.make indent ' ' ^ "for " ^ string_of_ident id ^ " in range(" ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ", " ^ string_of_int incr ^"):\n" ^ string_of_stmt (indent+2) stmt


  let string_of_program = function
    | Cstmt(stmt) -> string_of_stmt 0 stmt


let () =
  let in_channel = open_in "test.txt" in
  let lexbuf = Lexing.from_channel in_channel in
  let ast = Parser.program Lexer.token lexbuf in
  let out_channel = open_out "output.py" in
  match ast with
  | Cstmt(stmt) ->
    Printf.fprintf out_channel "%s\n" (string_of_program (Cstmt(stmt)));
  close_out out_channel;
  close_in in_channel
    
