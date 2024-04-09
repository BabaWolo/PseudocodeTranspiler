open Ast
module StringMap = Map.Make(String)

  (* Convert to python *)
  let string_of_ident ident = ident.id

  (* A hashtable of size 16, used for storing function declartions in the user-program *)
  let functions = (Hashtbl.create 16 : (string, expr list * stmt) Hashtbl.t)

  (* Recursive function checking the expressions of an expr list are equal to identifiers *)
  let rec check_expr_list = function
    | [] -> ()
    | Eident _ :: tl -> check_expr_list tl
    | _ -> raise (Failure "Arguments must be identifiers")

  let required_imports = ref []

  (* Add import if not already in list. The ! operator is used for dereferencing *)
  let add_import import =
    if not (List.mem import !required_imports) then
      required_imports := import :: !required_imports

  let rec string_of_expr = function
  | Eident(id) -> string_of_ident id
  | Ecst(x) ->
    begin
      match x with
      | Cint(i) -> string_of_int i
      | Cfloat(f) -> string_of_float f
    end
  | Eattribute(e1, attribute_name) ->
    let attribute_name = string_of_ident attribute_name in
    begin
      match attribute_name with
      | "next" | "prev" | "key" | "head" -> 
        add_import "from classes.linkedlist import LinkedList";
        string_of_expr e1 ^ "." ^ attribute_name
      | "length" | "size" -> "len(" ^ string_of_expr e1 ^ ")"
      | "top" -> string_of_expr e1 ^ "[-1]"
      | "tail" -> string_of_expr e1 ^ "[0]"
      | _ -> failwith "Attribute not supported"
    end
  | Elist(expr_list) ->
    "[" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ "]"
  | Etuple(expr_list) ->
    "(" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ ")"
  | Eget(id, index) ->
    string_of_ident id ^ "[" ^ string_of_expr index ^ "]"
  | Ecall(id, args) -> 
    let func_name = string_of_ident id in
    let args_str = String.concat ", " (List.map string_of_expr args) in
    let func_call = func_name ^ "(" ^ args_str ^ ")" in
    begin
      match func_name with
      | "ceil" | "floor" | "round" ->
        add_import "import math";
        "math." ^ func_call
      | "newLinkedList" ->
        add_import "from classes.linkedlist import LinkedList";
        "LinkedList(" ^ args_str ^ ")"
      | _ -> 
        func_call
    end
  | Ebinop(binop, e1, e2) -> 
    let x = string_of_expr e1 in
    let y = string_of_expr e2 in
    begin
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
    end
  | Eunop(unop, e) ->
    let x = string_of_expr e in
    begin
      match unop with
      | Uneg -> "-" ^ x
      | Uplus -> "+" ^ x
    end


  (* Recursive function for translating statements into python *)
  let rec string_of_stmt indent = function
    | Ssort(id) ->
      String.make indent ' ' ^ string_of_ident id ^ ".sort()\n"
    | Sassign(e1, e2) ->
      let lhs = match e1 with
        | Eident(id) -> string_of_ident id
        | Eattribute(e, id) -> string_of_expr e ^ "." ^ string_of_ident id
        | Eget(id, index) -> string_of_ident id ^ "[" ^ string_of_expr index ^ "]"
        | Etuple(expr_list) -> "(" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ ")"
        | _ -> failwith "Left-hand side of assignment must be an identifier or attribute"
      in
      String.make indent ' ' ^ lhs ^ " = " ^ string_of_expr e2 ^ "\n"
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
      (* Calling function which checks parameters are equal to identifiers *)
      let _ = check_expr_list args in
      Hashtbl.add functions (string_of_ident id) (args, stmt);
      String.make indent ' ' ^ "def " ^ string_of_ident id ^ "(" ^ (String.concat ", " (List.map string_of_expr args)) ^ ")" ^ ":\n" ^ string_of_stmt (indent+2) stmt ^ "\n"
    | Snewlist(id, list) ->
      begin
        match string_of_ident list with
        | li when li = "hashtable" -> String.make indent ' ' ^ string_of_ident id ^ " = " ^ "{}" ^ "\n"
        | li when li = "queue" || li = "stack" || li = "array" -> String.make indent ' ' ^ string_of_ident id ^ " = " ^ "[]" ^ "\n"
        | _ -> failwith (string_of_ident id ^ " must be of array, queue, stack, or hashtable")
      end
    | Sfor(id, e1, e2, stmt, incr) ->
      String.make indent ' ' ^ "for " ^ string_of_ident id ^ " in range(" ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ", " ^ string_of_int incr ^"):\n" ^ string_of_stmt (indent+2) stmt
    | Swhile(e, stmt) ->
      String.make indent ' ' ^ "while " ^ string_of_expr e ^ ":\n" ^ string_of_stmt (indent+2) stmt ^ "\n"
    | Sdowhile(e, stmt) ->
      String.make indent ' ' ^ "while True:\n" ^ string_of_stmt (indent+2) stmt ^ String.make (indent+2) ' ' ^ "if not " ^ string_of_expr e ^ ":\n" ^ String.make (indent+4) ' ' ^ "break\n\n"
    | Srepeat(e, stmt) ->
      String.make indent ' ' ^ "while True:\n" ^ string_of_stmt (indent+2) stmt ^ String.make (indent+2) ' ' ^ "if " ^ string_of_expr e ^ ":\n" ^ String.make (indent+4) ' ' ^ "break\n\n"
    | Sbreak ->
      String.make indent ' ' ^ "break\n"
    | Scontinue ->
      String.make indent ' ' ^ "continue\n"
    | Serror msg ->
      String.make indent ' ' ^ "raise ValueError('" ^ msg ^ "')\n"

  (* let string_of_program = function
    | Cstmt(stmt) -> string_of_stmt 0 stmt *)

  
  let generate_code = function
  | Cstmt(stmt) ->
    let code = string_of_stmt 0 stmt in
    let imports = String.concat "\n" !required_imports in
    if imports <> "" then
      imports ^ "\n\n" ^ code
    else
      code

(* Main function for reading in the file and writing to a new file *)
let () =
  let in_channel = open_in "test.txt" in
  let lexbuf = Lexing.from_channel in_channel in
  let ast = 
    try
      Parser.program Lexer.token lexbuf
    with
    | Parser.Error ->
      let curr = lexbuf.Lexing.lex_curr_p in
      let line = curr.Lexing.pos_lnum in
      let cnum = curr.Lexing.pos_cnum - curr.Lexing.pos_bol in
      let tok = Lexing.lexeme lexbuf in
      Printf.eprintf "Syntax error at line %d, column %d, token %s\n" line cnum tok;
      exit (-1) 
  in
  let out_channel = open_out "output.py" in
  let code = generate_code ast in
  Printf.fprintf out_channel "%s\n" code;
  close_out out_channel;
  close_in in_channel
    
