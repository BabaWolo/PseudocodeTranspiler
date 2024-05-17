open Ast
open Utils

let string_of_type = function
  | Tint -> "int "
  | Tfloat -> "float "
  | Tstring -> "String "
  | Tnil -> "None "
  | Tlist typ -> "List<" ^ string_of_type typ ^ "> "
  | _ -> failwith "Unsupported type"

let string_of_type_opt = function
| Some typ -> string_of_type typ
| None -> "None"

let get_type = function
  | Ecst (_, typ) -> typ
  | Ebinop (_, _, _, typ) -> typ
  | Eunop (_, _, typ) -> typ
  | Eident ident -> ident.typ
  | Ecall (_, _, typ) -> typ
  | Elist(_, typ) -> typ
  | Eget (_, _, typ) -> typ
  | Eattribute (_, _, typ) -> typ
  | Etuple (_, typ) -> typ

let rec infer_expr = function
  | Ecst (Cint i, _) -> Ecst (Cint i, Some Tint)
  | Ecst (Cfloat f, _) -> Ecst (Cfloat f, Some Tfloat)
  | Ecst (Cstring s, _) -> Ecst (Cstring s, Some Tstring)
  | Ecst (Cnil, _) -> Ecst (Cnil, Some Tnil)
  | Ecst (Cinfinity, _) -> Ecst (Cinfinity, Some Tfloat)
  | Ebinop (op, e1, e2, _) -> 
      let e1 = infer_expr e1 in
      let e2 = infer_expr e2 in
      let t1 = get_type e1 in
      let t2 = get_type e2 in
      if t1 = t2 then Ebinop (op, e1, e2, t1) else failwith "Type error in binary operation"
  | Eunop (op, e, _) -> 
      let e = infer_expr e in
      Eunop (op, e, get_type e)
  | Eident ident -> 
    (* Check if ident arg has been inferred *)
    let ident_type = ident.typ in
    if ident_type != None then 
      Eident ident
    else 
      (* Check if inferred ident exists in scope map *)
      begin
      match lookup_ident (string_of_ident ident) !current_scope_id with
      | Some (Expr (Eident inferred_ident)) ->
        if inferred_ident.typ = None then failwith "Unannotated identifier found"
        else Eident inferred_ident
      | _ -> failwith "Identifier not found in scope"
      end
  | Ecall (f, args, _) -> 
    let args = List.map infer_expr args in
    let arg_types = List.filter_map get_type args in
    Ecall (f, args, Some (Ttuple arg_types))
  | Elist(elems, _) -> 
      let elems = List.map infer_expr elems in
      let elem_types = List.filter_map get_type elems in
      let elem_type = List.hd elem_types in
      Elist (elems, Some (Tlist elem_type))
  | Eget (f, e, _) -> 
      begin
        let scope_ident = lookup_ident (string_of_ident f) !current_scope_id in
        match scope_ident with
        | Some Expr(Eident(ident)) -> 
          begin
          match ident.typ with
          | Some (Tlist typ) -> 
            let e' = infer_expr e in
            Eget (f, e', Some typ)
          | _ -> failwith "Type error in get operation"
          end
        | _ -> print_endline("Typ: " ^ string_of_type_opt f.typ);
          failwith "Type error in get operation"
      end
  | Eattribute (e, a, _) -> 
      let e = infer_expr e in
      Eattribute (e, a, get_type e)
  | Etuple (elems, _) -> 
      let elems = List.map infer_expr elems in
      let elem_types = List.filter_map get_type elems in
      Etuple (elems, Some (Ttuple elem_types))

let rec infer_stmt = function
  | Sassign (Eident ident, expr, _) ->
      let scope_ident = lookup_ident (string_of_ident ident) !current_scope_id in
      let e = infer_expr expr in
      let typ = get_type e in
      let e_ident = Eident { ident with typ = typ } in
      let bool_val =
        match scope_ident with
        | None -> 
          add_ident (string_of_ident ident) (Expr e_ident) !current_scope_id;
          true
        | Some _ -> false
      in
      Sassign (e_ident, expr, Some bool_val)
  | Seval expr ->
      ignore(infer_expr expr);
      Seval expr
  | Sblock stmts ->
      let stmts = List.map infer_stmt stmts in
      Sblock stmts
  | Sprint expr ->
      ignore(infer_expr expr);
      Sprint expr
  | Sif (cond, then_stmt, else_stmt) ->
      ignore(enter_scope());
      let cond = infer_expr cond in
      let then_stmt = infer_stmt then_stmt in
      let else_stmt = infer_stmt else_stmt in
      ignore(leave_scope());
      Sif (cond, then_stmt, else_stmt)
  | Sreturn expr ->
      let inferred_expr = infer_expr expr in
      ignore(add_ident "return" (Expr inferred_expr) !current_scope_id); (* Add return type to scope map *)
      Sreturn inferred_expr
  | Sdef (ident, params, stmt) ->
  (* Lookup Ecall of the function to determine param types based on its arg types *)
  begin
  match lookup_ident (string_of_ident ident) !current_scope_id with
  | Some (Expr (Ecall (_, expr_list, _))) ->
    let inferred_args = List.map infer_expr expr_list in
    let arg_types = List.filter_map get_type inferred_args in
    (* Increment scope id to represent the scope of its body *)
    ignore(enter_scope());
    (* Update params in scope map and keep the updated params for later use *)
    let updated_params = List.map2 (fun param arg ->
      match param with
      | Eident param_ident -> 
        let inferred_type = get_type arg in
        print_endline("Param: " ^ string_of_ident param_ident ^ " Type: " ^ string_of_type_opt inferred_type);
        let updated_ident = { param_ident with typ = inferred_type } in
        add_ident (string_of_ident param_ident) (Expr (Eident updated_ident)) !current_scope_id;
        Eident updated_ident
      | _ -> failwith ("Parameters must be identifiers")
    ) params inferred_args in
    let stmt = infer_stmt stmt in
    let return_expr = lookup_ident "return" !current_scope_id in
    ignore(leave_scope());
    begin
    match return_expr with
    | Some (Expr return_expr) -> 
      let return_type = get_type return_expr in
      let ident = { ident with typ = return_type } in
      print_endline ("\027[92mFunction " ^ string_of_ident ident ^ "\027[0m \n\027[92m|\027[0m  Param types: " ^ (String.concat ", " (List.map string_of_type arg_types)) ^ "\n\027[92m|\027[0m  Return type: " ^ (string_of_type_opt return_type));
      Sdef (ident, updated_params, stmt)
    | _ -> failwith "Return type not found in scope"
    end
  | _ -> failwith "Identifier not found in scope or not an expression list"
  end  
  | Sfor (ident, expr1, expr2, stmt, i) ->
      ignore(enter_scope());
      let expr1 = infer_expr expr1 in
      let expr2 = infer_expr expr2 in
      let typ = get_type expr1 in
      let ident = { ident with typ = typ } in
      add_ident (string_of_ident ident) (Expr (Eident(ident))) !current_scope_id;
      let stmt = infer_stmt stmt in
      print_endline("Typ: " ^ string_of_type_opt typ);
      ignore(leave_scope());
      Sfor (ident, expr1, expr2, stmt, i)
  | Snewlist (ident, expr, _) ->
      let expr = infer_expr expr in
      Snewlist (ident, expr, ident)
  | Swhile (expr, stmt) ->
      ignore(enter_scope());
      let expr = infer_expr expr in
      let stmt = infer_stmt stmt in
      ignore(leave_scope());
      Swhile (expr, stmt)
  | Sdowhile (expr, stmt) ->
      ignore(enter_scope());
      let expr = infer_expr expr in
      let stmt = infer_stmt stmt in
      ignore(leave_scope());
      Sdowhile (expr, stmt)
  | Srepeat (expr, stmt) ->
      let expr = infer_expr expr in
      let stmt = infer_stmt stmt in
      Srepeat (expr, stmt)
  | Sbreak -> Sbreak
  | Scontinue -> Scontinue
  | Ssort ident -> Ssort ident
  | Sexchange (expr1, expr2) ->
      let expr1 = infer_expr expr1 in
      let expr2 = infer_expr expr2 in
      Sexchange (expr1, expr2)
  | Srandom (expr1, expr2) ->
      let expr1 = infer_expr expr1 in
      let expr2 = infer_expr expr2 in
      Srandom (expr1, expr2)
  | Scomment str -> Scomment str
  | _ -> failwith "Unsupported statement"



(* let rec infer_ast = function
  | [] -> ()
  | Cstmt stmt :: rest ->
      infer_stmt stmt;
      infer_ast rest *)
