(* Part of a transpiler - A transpiler converts source code from one programming language to another, 
   while a compiler translates source code into machine code. *)
open Ast
open Utils
module StringMap = Map.Make(String)

  let rec string_of_expr = function
  | Eident(id) -> string_of_ident id
  | Ecst(x) ->
    begin
      match x with
      | Cint(i) -> string_of_int i
      | Cfloat(f) -> string_of_float f
      | Cstring(s) -> "" ^ s ^ ""
      | Cnil -> "None"
      | Cinfinity -> "float('inf')"
    end
  | Eattribute(e1, attribute_name) ->
    let attribute_name = string_of_ident attribute_name in
    begin
      match attribute_name with
      | "next" | "prev" | "key" | "head" | "left" | "right" | "p" | "root" | "top" | "tail" -> 
        add_import "from lib.pseudolibrary import PseudoLibrary";
        "PseudoLibrary." ^ attribute_name ^ "(" ^ string_of_expr e1 ^ ")"
      | "length" | "size" -> "len(" ^ string_of_expr e1 ^ ")"
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
        add_import "from lib.pseudolibrary import PseudoLibrary";
        "PseudoLibrary.LinkedList(" ^ args_str ^ ")"
      | "newBinaryTree" ->
        add_import "from lib.pseudolibrary import PseudoLibrary";
        "PseudoLibrary.BinaryTree(" ^ args_str ^ ")"
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
    | Serror(s) -> 
      String.make indent ' ' ^ "raise Exception(" ^ s ^ ")\n"
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
    | Sif(e, stmt, Sif(e2, stmt2, Sblock [])) ->
      String.make indent ' ' ^ "if " ^ string_of_expr e ^ ":\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "elif " ^ string_of_expr e2 ^ ":\n" ^ string_of_stmt (indent+2) stmt2
    | Sif(e, stmt, Sif(e2, stmt2, else_stmts)) ->
      String.make indent ' ' ^ "if " ^ string_of_expr e ^ ":\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "elif " ^ string_of_expr e2 ^ ":\n" ^ string_of_stmt (indent+2) stmt2 ^ String.make indent ' ' ^ "else:\n" ^ string_of_stmt (indent+2) else_stmts
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
    | Snewlist(id, expr, list) ->
      begin
        match string_of_expr expr with
        | "None" ->
          begin
            match string_of_ident list with
            | li when li = "hashtable" -> String.make indent ' ' ^ string_of_ident id ^ " = " ^ "{}" ^ "\n"
            | li when li = "queue" || li = "stack" || li = "array" -> String.make indent ' ' ^ string_of_ident id ^ " = " ^ "[]" ^ "\n"
            | _ -> failwith (string_of_ident id ^ " must be of array, queue, stack, or hashtable")
          end
        | _ ->
          begin
            match string_of_ident list with
            | li when li = "hashtable" -> String.make indent ' ' ^ string_of_ident id ^ " = " ^ "{i: None for i in range(" ^ string_of_expr expr ^ ")}" ^ "\n"
            | li when li = "queue" || li = "stack" || li = "array" -> String.make indent ' ' ^ string_of_ident id ^ " = " ^ "[None] * (" ^ string_of_expr expr ^")" ^ "\n"
            | _ -> failwith (string_of_ident id ^ " must be of array, queue, stack, or hashtable")
          end
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
    | Sexchange(e1, e2) -> 
      String.make indent ' ' ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ " = " ^ string_of_expr e2 ^ ", " ^ string_of_expr e1 ^ "\n"
    | Srandom(e1, e2) ->
      add_import "import random";
      String.make indent ' ' ^ "random.randint(" ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ")\n"
    | Scomment(s) ->
      String.make indent ' ' ^ "#" ^ (String.sub s 2 ((String.length s) - 2)) ^ "\n"

  (* let string_of_program = function
    | Cstmt(stmt) -> string_of_stmt 0 stmt *)

  
  let generate_code = function
  | stmt ->
    let code = string_of_stmt 0 stmt in
    let imports = String.concat "\n" !required_imports in
    if imports <> "" then
      imports ^ "\n\n" ^ code
    else
      code

    
