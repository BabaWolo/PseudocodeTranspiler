(* Part of a transpiler - A transpiler converts source code from one programming language to another, 
   while a compiler translates source code into machine code. *)
open Ast
open Utils
open Type_reconstruction
module StringMap = Map.Make(String)

let function_defs = (Hashtbl.create 10 : (string, string) Hashtbl.t)

let rec get_java_type = function
  | Some Tint -> "int "
  | Some Tfloat -> "float "
  | Some Tstring -> "String "
  | Some Tnil -> "None "
  | Some Tlist typ -> 
    add_import "import java.util.ArrayList;";
    "ArrayList<" ^ get_java_wrapper_type (Some typ) ^ "> "
  | None -> failwith "Type not inferred"
  | _ -> failwith "Unsupported type"

and get_java_wrapper_type = function
  | Some Tint -> "Integer "
  | Some Tfloat -> "Float "
  | Some Tstring -> "String "
  | Some Tnil -> "None "
  | Some Tlist typ -> "ArrayList<" ^ get_java_wrapper_type (Some typ) ^ "> "
  | None -> failwith "Type not inferred"
  | _ -> failwith "Unsupported type"

let rec string_of_expr = function
| Eident(id) -> string_of_ident id
| Ecst(x,_) ->
  begin
    match x with
    | Cint(i) -> string_of_int i
    | Cfloat(f) -> string_of_float f
    | Cstring(s) -> "" ^ s ^ ""
    | Cnil -> "null"
    | Cinfinity -> failwith "Infinity not supported in Java"
  end
| Eattribute(e1, attribute_name,_) ->
  let attribute_name = string_of_ident attribute_name in
  begin
    match attribute_name with
    (* | "next" | "prev" | "key" | "head" | "left" | "right" | "p" | "root" | "top" | "tail" -> 
      add_import "from lib.pseudolibrary import PseudoLibrary";
      "PseudoLibrary." ^ attribute_name ^ "(" ^ string_of_expr e1 ^ ")" *)
    | "length" | "size" -> string_of_expr e1 ^ ".size()"
    | _ -> failwith "Attribute not supported"
  end
| Elist(expr_list,_) ->
  add_import "import java.util.ArrayList;";
  add_import "import java.util.Arrays;";
  "new ArrayList<>(Arrays.asList(" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ "))"
| Etuple(expr_list,_) ->
  "(" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ ")"
| Eget(id, index,_) ->
  string_of_ident id ^ ".get(" ^ string_of_expr index ^ ")"
| Ecall(id, args,_) -> 
  let func_name = string_of_ident id in
  let args_str = String.concat ", " (List.map string_of_expr args) in
  let func_call = func_name ^ "(" ^ args_str ^ ")" in
  begin
    match func_name with
    | "ceil" | "floor" | "round" ->
      add_import "import java.lang.Math;";
      "Math." ^ func_call
    (* | "newLinkedList" ->
      add_import "from lib.pseudolibrary import PseudoLibrary";
      "PseudoLibrary.LinkedList(" ^ args_str ^ ")"
    | "newBinaryTree" ->
      add_import "from lib.pseudolibrary import PseudoLibrary";
      "PseudoLibrary.BinaryTree(" ^ args_str ^ ")" *)
    | _ -> 
      func_call
  end
| Ebinop(binop, e1, e2,_) -> 
  let x = string_of_expr e1 in
  let y = string_of_expr e2 in
  begin
    match binop with
    | Badd -> x ^ " + " ^ y
    | Bsub -> x ^ " - " ^ y
    | Bdiv -> x ^ " / " ^ y
    | Bmul -> x ^ " * " ^ y
    | Bmod -> x ^ " % " ^ y
    | Band -> x ^ " && " ^ y
    | Bor -> x ^ " || " ^ y
    | Beq -> x ^ " == " ^ y
    | Bneq -> x ^ " != " ^ y
    | Blt -> x ^ " < " ^ y
    | Ble -> x ^ " <= " ^ y
    | Bgt -> x ^ " > " ^ y
    | Bge -> x ^ " >= " ^ y
  end
| Eunop(unop, e,_) ->
  let x = string_of_expr e in
  begin
    match unop with
    | Uneg -> "-" ^ x
    | Uplus -> "+" ^ x
  end


and string_of_arg = function
  | Eident(id) -> get_java_wrapper_type id.typ ^ string_of_ident id
  | _ -> failwith "Unsupported argument"

(* Recursive function for translating statements into java *)
let [@warning "-8"] rec string_of_stmt indent = function
  | Sassign(e1, e2, Some is_new) ->
    let lhs = match e1 with
    | Eident(id) -> if is_new then get_java_type id.typ ^ string_of_ident id else string_of_ident id
    (* | Eattribute(e, id,_) -> string_of_expr e ^ "." ^ string_of_ident id
    | Eget(id, index,_) -> string_of_ident id ^ "[" ^ string_of_expr index ^ "]"
    | Etuple(expr_list,_) -> "(" ^ (String.concat ", " (List.map string_of_expr expr_list)) ^ ")" *)
    | _ -> failwith "Left-hand side of assignment must be an identifier or attribute"
    in
    String.make indent ' ' ^ lhs ^ " = " ^ string_of_expr e2 ^ ";\n"
  | Seval(e) ->
    String.make indent ' ' ^ string_of_expr e ^ ";\n"
  | Sblock(stmts) ->
    String.concat "" (List.map (string_of_stmt (indent)) stmts)
  | Sif(e, stmt, Sblock []) ->
    String.make indent ' ' ^ "if (" ^ string_of_expr e ^ ") {\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "}\n"
  | Sreturn e ->
    String.make indent ' ' ^ "return " ^ string_of_expr e ^ ";\n"
  | Sfor (id, e1, e2, stmt, incr) ->
    String.make indent ' ' ^ "for (" ^ get_java_type id.typ ^ string_of_ident id ^ " = " ^ string_of_expr e1 ^ "; " ^ string_of_ident id ^ " < " ^ string_of_expr e2 ^ "; " ^ string_of_ident id ^ " += " ^ string_of_int incr ^ ") {\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "}\n"
  | Swhile (e, stmt) ->
    String.make indent ' ' ^ "while (" ^ string_of_expr e ^ ") {\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "}\n"
  | Sdowhile (e, stmt) ->
    String.make indent ' ' ^ "do {\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "} while (" ^ string_of_expr e ^ ");\n"
  | Srepeat (e, stmt) ->
    String.make indent ' ' ^ "do {\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "} while (!(" ^ string_of_expr e ^ "));\n"
  | Sbreak ->
    String.make indent ' ' ^ "break;\n"
  | Scontinue ->
    String.make indent ' ' ^ "continue;\n"
  | Scomment s ->
    String.make indent ' ' ^ "//" ^ (String.sub s 2 ((String.length s) - 2)) ^ "\n"
  | Ssort id ->
    add_import "import java.util.Arrays";
    String.make indent ' ' ^ "Arrays.sort(" ^ string_of_ident id ^ ");\n"
  | Sexchange (e1, e2) ->
    (* Currently set type to int, but need to be changed to get the type of the expr *)
    String.make indent ' ' ^ "int temp = " ^ string_of_expr e1 ^ ";\n" ^ String.make indent ' ' ^ string_of_expr e1 ^ " = " ^ string_of_expr e2 ^ ";\n" ^ String.make indent ' ' ^ string_of_expr e2 ^ " = temp;\n"
  | Srandom (e1, e2) ->
    add_import "import java.util.Random";
    String.make indent ' ' ^ "Random rand = new Random();\n" ^ String.make indent ' ' ^ "int random = rand.nextInt((" ^ (string_of_expr e2) ^ "-" ^ (string_of_expr e1) ^"+1) + " ^ (string_of_expr e1) ^ ";\n"
  | Sprint e ->
    String.make indent ' ' ^ "System.out.println(" ^ string_of_expr e ^ ");\n"  
  | Sdef(id, args, stmt) ->
    (* Calling function which checks parameters are equal to identifiers *)
    let _ = check_expr_list args in
    add_function id args stmt;
    ""
  | _ -> failwith "Unsupported statement"


(* Add import if not already in list. The ! operator is used for dereferencing *)
and add_function id args stmt =
  (* Hashtable *)
  let id_string = string_of_ident id in
  if Hashtbl.mem function_defs id_string then
    failwith ("Function '" ^ id_string ^ "' already defined")
  else
    Hashtbl.add function_defs id_string ("  static " ^ get_java_wrapper_type id.typ ^ string_of_ident id ^ "(" ^ (String.concat ", " (List.map string_of_arg args)) ^ ")" ^ "{\n" ^ string_of_stmt 4 stmt ^ "  }\n")
(* 
TODO:
  | Snewlist(id, expr, list) ->
    (* let _ = check_expr_list args in *)
    String.make indent ' ' ^ "public " ^ get_java_type id.typ ^ string_of_ident id ^ "(" ^ (String.concat ", " (List.map (fun arg -> match arg with
    | Eident id -> (get_java_type id.typ) ^ string_of_ident id
    | _ -> string_of_expr arg) args)) ^ ")" ^ " {\n" ^ string_of_stmt (indent+2) stmt ^ String.make indent ' ' ^ "}\n"  
  | _ -> failwith "Unsupported statement"
    (*| Snewlist(id, expr, list) ->
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

*)
(* let string_of_program = function
  | Cstmt(stmt) -> string_of_stmt 0 stmt *)

  *)


let generate_code = function
| Cstmt(stmt) ->
  scope_id_counter := 0;
  let stmt = infer_stmt stmt in
  let code = string_of_stmt 4 stmt in
  let imports = String.concat "\n" !required_imports in
  let class_def = "class Main {\n" in
  let functions = String.concat "" (Hashtbl.fold (fun _ v acc -> v :: acc) function_defs []) in
  let code_prefix = "  public static void main(String[] args) {\n" in
  let code_suffix = "  }\n}" in
  if imports <> "" then
    imports ^ "\n\n" ^ class_def ^ functions ^ code_prefix ^ code ^ code_suffix
  else
    class_def ^ functions ^ code_prefix ^ code ^ code_suffix

