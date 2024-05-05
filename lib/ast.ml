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
  | Etuple of expr list (* (e1,e2,...) *)


and command = 
  | Cstmt of stmt
  
and constant =
  | Cint of int
  | Cfloat of float
  | Cstring of string
  | Cnil


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
  | Sdef of ident * expr list * stmt
  | Sfor of ident * expr * expr * stmt * int
  | Snewlist of ident * expr * ident
  | Swhile of expr * stmt
  | Sdowhile of expr * stmt
  | Srepeat of expr * stmt
  | Sbreak
  | Scontinue
  | Ssort of ident
  | Sexchange of expr * expr
  | Srandom of expr
  | Scomment of string
