type location = Lexing.position * Lexing.position
type ident = { loc: location; id: string; }

type expr =
  | Ecst of constant               (* Constant *)
  | Ebinop of binop * expr * expr  (* Binary operation *)
  | Eunop of unop * expr  (* Unary operation *)
  | Eident of ident       (* Identifier *)
  | Ecall of ident * expr list
  | Elist of expr list (* [e1,e2,...] *)
  | Eget of ident * expr (* e1[e2] *)
  | Eattribute of expr * ident (* e1.e2 *)


and command = 
  | Cstmt of stmt
  
and constant =
  | Cint of int
  | Cfloat of float


(* Define the types for binary operators *)
and binop =
  | Badd | Bsub | Bmul | Bdiv | Bmod
  | Beq | Bneq | Blt | Ble | Bgt | Bge
  | Band | Bor

and unop =
  | Uneg | Uplus

and stmt =
  | Sassign of expr * expr
  | Seval of expr
  | Sif of expr * stmt * stmt
  | Sprint of expr
  | Sreturn of expr
  | Sblock of stmt list
  | Sdef of ident * ident list * stmt
  | Sfor of ident * expr * expr * stmt * int
  | Swhile of expr * stmt
  | Sdowhile of expr * stmt
  | Srepeat of expr * stmt
  | Sbreak
  | Scontinue



(* Define the types for arithmetic expressions and variables *)
(* type location = Lexing.position * Lexing.position

type ident = { loc: location; id: string; } *)
(* 
type expr =
  | Ecst of constant               (* Constant *)
  | Ebinop of binop * expr * expr  (* Binary operation *)
(*   | Eunop of unop * expr  (* Unary operation *)
  | Eident of ident       (* Identifier *)
  | Elist of expr list (* [e1,e2,...] *)
  | Eget of expr * expr (* e1[e2] *) *)

and command = 
  | Cexpr of expr
  
and constant =
  (* | Cnone
  | Cbool of bool
  | Cstring of string *)
  | Cint of int

(* and unop =
  | Uneg (* -e *)
  | Unot not e *)

(* Define the types for binary operators *)
and binop =
  | Badd         Addition *)
(*   | Bsub         (* Subtraction *)
  | Bmul         (* Multiplication *)
  | Bdiv         (* Division *)
  | Bmod         (* Modulo *)
  | Beq         (* == *)    
  | Bneq        (* != *)
  | Blt         (* < *)
  | Ble         (* <= *)
  | Bgt         (* > *)
  | Bge         (* >= *)
  | Band        (* and *)
  | Bor         (* or *)
 *)
(* and stmt =
  | Sif of expr * stmt * stmt
  | Sreturn of expr
  | Sassign of ident * expr
  | Sprint of expr
  | Sblock of stmt list
  | Sfor of ident * expr * stmt
  | Seval of expr
  | Sset of expr * expr * expr (* e1[e2] = e3 *) *)

(* and def = ident * ident list * stmt

and file = def list * stmt *)
  (*
     
(* Abstract Syntax of Mini-Python *)

(* Parsed trees.
   This is the output of the parser and the input of the interpreter. *)

type location = Lexing.position * Lexing.position

type ident = { loc: location; id: string; }

type unop =
  | Uneg (* -e *)
  | Unot (* not e *)

type binop =
  | Badd | Bsub | Bmul | Bdiv | Bmod    (* + - * // % *)
  | Beq | Bneq | Blt | Ble | Bgt | Bge  (* == != < <= > >= *)
  | Band | Bor                          (* and or *)

type constant =
  | Cnone
  | Cbool of bool
  | Cstring of string
  | Cint of int64

type expr =
  | Ecst of constant
  | Eident of ident
  | Ebinop of binop * expr * expr
  | Eunop of unop * expr
  | Ecall of ident * expr list
  | Elist of expr list (* [e1,e2,...] *)
  | Eget of expr * expr (* e1[e2] *)

and stmt =
  | Sif of expr * stmt * stmt
  | Sreturn of expr
  | Sassign of ident * expr
  | Sprint of expr
  | Sblock of stmt list
  | Sfor of ident * expr * stmt
  | Seval of expr
  | Sset of expr * expr * expr (* e1[e2] = e3 *)

and def = ident * ident list * stmt

and file = def list * stmt
*)