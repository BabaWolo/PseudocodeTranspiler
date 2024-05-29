open Ast

let debug = ref false

let debug_print str =
  if !debug then
    print_endline str

let rec string_of_type = function
  | Tint -> "int "
  | Tfloat -> "float "
  | Tstring -> "String "
  | Tnil -> "None "
  | Tlist typ -> "List<" ^ string_of_type typ ^ "> "
  | _ -> failwith "Unsupported type"

let string_of_type_opt = function
| Some typ -> string_of_type typ
| None -> "None"

type scope_value =
  | Expr of expr
  | Stmt of stmt
  | Parent_scope_id of int
type scope = (string, scope_value) Hashtbl.t
type scope_map = (int, scope) Hashtbl.t

let string_of_ident ident = ident.id

let scope_map : scope_map = Hashtbl.create 16

let scope_id_counter = ref 0
let current_scope_id = ref 0
let parent_scope_id = ref 0

let initialize_global_scope () =
  let global_scope : scope = Hashtbl.create 16 in
  Hashtbl.add scope_map 0 global_scope

let increment_scope_id_counter () = 
  current_scope_id := !scope_id_counter + 1;
  incr scope_id_counter

(* Create a new scope and return its id *)
let enter_scope () =
  incr scope_id_counter;
  debug_print ("Creating new scope " ^ string_of_int !scope_id_counter);
  let new_scope = Hashtbl.create 16 in
  Hashtbl.add new_scope "parent_scope_id" (Parent_scope_id !current_scope_id);
  Hashtbl.add scope_map !scope_id_counter new_scope;
  current_scope_id := !scope_id_counter;  (* Update the current scope ID *)
  !scope_id_counter

let leave_scope () = 
  match Hashtbl.find_opt scope_map !current_scope_id with
  | Some scope ->
    (match Hashtbl.find_opt scope "parent_scope_id" with
     | Some (Parent_scope_id inner_parent_scope_id) -> 
      current_scope_id := inner_parent_scope_id;  (* Update the current scope ID *)
      !current_scope_id
     | _ -> 0)
  | None -> 0

let rec lookup_ident id scope_id =
  debug_print ("Looking up " ^ id ^ " in scope " ^ string_of_int scope_id);
  match Hashtbl.find_opt scope_map scope_id with
  | Some scope ->
    (match Hashtbl.find_opt scope id with
    | Some value -> 
      begin
      match value with
      | Expr Eident ident ->
        debug_print ("-> found " ^ id ^ " in scope " ^ string_of_int scope_id);
        debug_print (id ^ " type = " ^ string_of_type_opt ident.typ);
        Some value
      | _ -> Some value
      end
    | None ->
        debug_print ("-> not found " ^ id ^ " in scope " ^ string_of_int scope_id);
       (match Hashtbl.find_opt scope "parent_scope_id" with
        | Some (Parent_scope_id parent_scope_id) -> lookup_ident id parent_scope_id
        | _ -> None))
  | None -> debug_print ("Scope " ^ string_of_int scope_id ^ " not found");
    None

let add_ident id scope_val scope_id =
  debug_print ("Adding " ^ id ^ " to scope " ^ string_of_int scope_id);
  match Hashtbl.find_opt scope_map scope_id with
  | Some scope -> Hashtbl.add scope id scope_val
  | None -> ()

let update_ident id new_val scope_id =
  match Hashtbl.find_opt scope_map scope_id with
  | Some scope ->
    debug_print ("Updating " ^ id ^ " in scope " ^ string_of_int scope_id);
    Hashtbl.replace scope id new_val
  | None -> 
    debug_print ("Scope " ^ string_of_int scope_id ^ " not found");
    ()

let () = 
  initialize_global_scope ();
  if Array.length Sys.argv > 3 && Sys.argv.(3) = "true" then debug := true

(* Recursive function checking the expressions of an expr list are equal to identifiers *)
let rec check_expr_list = function
  | [] -> ()
  | Eident _ :: tl -> check_expr_list tl
  | _ -> raise (Failure "Arguments must be identifiers")

let required_imports : string list ref = ref []

(* Add import if not already in list. The ! operator is used for dereferencing *)
let add_import import =
  if not (List.mem import !required_imports) then
    required_imports := import :: !required_imports

let rec string_of_expr = function
| Ecst (constant, _) -> string_of_constant constant 
| Ebinop (op, expr1, expr2, _) ->
    Printf.sprintf "(%s %s %s)" (string_of_expr expr1) (string_of_binop op) (string_of_expr expr2)
| Eunop (op, expr, _) ->
    Printf.sprintf "%s%s" (string_of_unop op) (string_of_expr expr)
| Eident ident -> ident.id
| Ecall (ident, args, _) ->
    Printf.sprintf "%s(%s)" ident.id (String.concat ", " (List.map string_of_expr args))
| Elist (exprs, _) ->
    Printf.sprintf "[%s]" (String.concat ", " (List.map string_of_expr exprs))
| Eget (ident, expr, _) ->
    Printf.sprintf "%s[%s]" ident.id (string_of_expr expr)
| Eattribute (expr, ident, _) ->
    Printf.sprintf "%s.%s" (string_of_expr expr) ident.id
| Etuple (exprs,_) ->
    Printf.sprintf "(%s)" (String.concat ", " (List.map string_of_expr exprs))

and string_of_binop = function
| Badd -> "+"
| Bsub -> "-"
| Bmul -> "*"
| Bdiv -> "/"
| Bmod -> "%"
| Beq -> "=="
| Bneq -> "!="
| Blt -> "<"
| Ble -> "<="
| Bgt -> ">"
| Bge -> ">="
| Band -> "&&"
| Bor -> "||"

and string_of_unop = function
| Uneg -> "-"
| Uplus -> "+"

and string_of_constant = function
| Cint i -> string_of_int i
| Cfloat f -> string_of_float f
| Cstring s -> s
| Cnil -> "nil"
| Cinfinity -> "infinity"

let rec string_of_stmt = function
| Sassign (expr1, expr2, _) ->
    Printf.sprintf "%s = %s;" (string_of_expr expr1) (string_of_expr expr2)
| Seval expr ->
    string_of_expr expr ^ ";"
| Sif (expr, stmt1, stmt2) ->
    Printf.sprintf "if %s { %s } else { %s }" (string_of_expr expr) (string_of_stmt stmt1) (string_of_stmt stmt2)
| Sprint expr ->
    Printf.sprintf "print(%s);" (string_of_expr expr)
| Sreturn expr ->
    Printf.sprintf "return %s;" (string_of_expr expr)
| Sblock stmts ->
    "{ " ^ String.concat " " (List.map string_of_stmt stmts) ^ " }"
| Sdef (ident, params, body) ->
    Printf.sprintf "def %s(%s) %s" ident.id (String.concat ", " (List.map string_of_expr params)) (string_of_stmt body)
| Sfor (ident, expr1, expr2, body, _) ->
    Printf.sprintf "for %s = %s to %s %s" ident.id (string_of_expr expr1) (string_of_expr expr2) (string_of_stmt body)
| Snewlist (ident1, expr, ident2) ->
    Printf.sprintf "%s = new list(%s, %s);" ident1.id (string_of_expr expr) ident2.id
| Swhile (expr, body) ->
    Printf.sprintf "while %s { %s }" (string_of_expr expr) (string_of_stmt body)
| Sdowhile (expr, body) ->
    Printf.sprintf "do { %s } while %s;" (string_of_stmt body) (string_of_expr expr)
| Srepeat (expr, body) ->
    Printf.sprintf "repeat { %s } until %s;" (string_of_stmt body) (string_of_expr expr)
| Sbreak -> "break;"
| Scontinue -> "continue;"
| Ssort ident ->
    Printf.sprintf "sort %s;" ident.id
| Sexchange (expr1, expr2) ->
    Printf.sprintf "exchange %s, %s;" (string_of_expr expr1) (string_of_expr expr2)
| Srandom (expr1, expr2) ->
    Printf.sprintf "random %s %s;" (string_of_expr expr1) (string_of_expr expr2)
| Scomment str ->
    "// " ^ str
| Serror str ->
    Printf.sprintf "error %s;" str

and string_of_ast = function
| Cstmt stmt -> string_of_stmt stmt
  