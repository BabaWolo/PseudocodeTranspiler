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