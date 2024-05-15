open Ast

let string_of_ident ident = ident.id

(* A hashtable of size 16, used for storing function declartions in the user-program *)
let functions = (Hashtbl.create 16 : (string, expr list * stmt) Hashtbl.t)

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
| Ecst constant -> string_of_constant constant
| Ebinop (op, expr1, expr2) ->
    Printf.sprintf "(%s %s %s)" (string_of_expr expr1) (string_of_binop op) (string_of_expr expr2)
| Eunop (op, expr) ->
    Printf.sprintf "%s%s" (string_of_unop op) (string_of_expr expr)
| Eident ident -> ident.id
| Ecall (ident, args) ->
    Printf.sprintf "%s(%s)" ident.id (String.concat ", " (List.map string_of_expr args))
| Elist exprs ->
    Printf.sprintf "[%s]" (String.concat ", " (List.map string_of_expr exprs))
| Eget (ident, expr) ->
    Printf.sprintf "%s[%s]" ident.id (string_of_expr expr)
| Eattribute (expr, ident) ->
    Printf.sprintf "%s.%s" (string_of_expr expr) ident.id
| Etuple exprs ->
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
| Sassign (expr1, expr2) ->
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
  