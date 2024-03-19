open Ast
  let rec eval_expr = function
  | Ecst(Cint(x)) -> x
  | Ebinop(binop, e1, e2) -> 
    let x = eval_expr e1 in
    let y = eval_expr e2 in
    match binop with
    | Badd -> x + y
    | Bsub -> x - y
    | Bdiv -> x / y
    | Bmul -> x * y
    | Bmod -> x mod y
    | Band -> if x = 1 && y = 1 then 1 else 0
    | Bor -> if x = 1 || y = 1 then 1 else 0
    | Beq -> if x = y then 1 else 0
    | Bneq -> if x != y then 1 else 0
    | Blt -> if x < y then 1 else 0
    | Ble -> if x <= y then 1 else 0
    | Bgt -> if x > y then 1 else 0
    | Bge -> if x >= y then 1 else 0
    
    




    
let () =
  let lexbuf = Lexing.from_string "3 == 2 or 2 == 2 or 2 == 3000 " in
  let ast = Parser.program Lexer.token lexbuf in

  match ast with
  | Cexpr(e)  ->
    let result = eval_expr e in
    print_endline (string_of_int result)

(* 
    open Ast *)

    (* Det her skal ind i en anden fil 
type value =
  | Int of int
  | Bool of bool*)
(* 
let rec eval_expr = function
  | Ecst(Cint(x)) -> Int(x)
  | Ebinop(binop, e1, e2) -> 
    let x = eval_expr e1 in
    let y = eval_expr e2 in
    match binop with
    | Badd -> Int((get_int x) + (get_int y))
    | Bsub -> Int((get_int x) - (get_int y))
    | Bdiv -> Int((get_int x) / (get_int y))
    | Bmul -> Int((get_int x) * (get_int y))
    | Bmod -> Int((get_int x) mod (get_int y))
    | Band -> Bool((get_bool x) && (get_bool y))
    | Bor -> Bool((get_bool x) || (get_bool y))
    | Beq -> Bool((get_int x) = (get_int y))
    | Bneq -> Bool((get_int x) != (get_int y))
    | Blt -> Bool((get_int x) < (get_int y))
    | Ble -> Bool((get_int x) <= (get_int y))
    | Bgt -> Bool((get_int x) > (get_int y))
    | Bge -> Bool((get_int x) >= (get_int y))

and get_int = function
  | Int(x) -> x
  | Bool(_) -> failwith "Expected integer, got boolean"

and get_bool = function
  | Bool(b) -> b
  | Int(_) -> failwith "Expected boolean, got integer"

let () =
  let lexbuf = Lexing.from_string "3 == 2 or 2 == 2 or 2 == 3000 " in
  let ast = Parser.program Lexer.token lexbuf in

  match ast with
  | Cexpr(e)  ->
    let result = eval_expr e in
    match result with
    | Int(i) -> print_endline (string_of_int i)
    | Bool(b) -> print_endline (string_of_bool b) *)