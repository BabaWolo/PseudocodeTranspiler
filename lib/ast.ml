type location = Lexing.position * Lexing.position

type typ =
  | Tint
  | Tfloat
  | Tstring
  | Tnil
  | Tlist of typ
  | Ttuple of typ list
  | Tfunction of typ list option * typ

type ident = { loc: location; id: string; typ: typ option }

type expr =
  | Ecst of constant * typ option               (* Constant *)
  | Ebinop of binop * expr * expr * typ option  (* Binary operation *)
  | Eunop of unop * expr * typ option  (* Unary operation *)
  | Eident of ident       (* Identifier *)
  | Ecall of ident * expr list * typ option
  | Elist of expr list * typ option (* [e1,e2,...] *)
  | Eget of ident * expr * typ option (* e1[e2] *)
  | Eattribute of expr * ident * typ option (* e1.e2 *)
  | Etuple of expr list * typ option (* (e1,e2,...) *)


and command = 
  | Cstmt of stmt
  
and constant =
  | Cint of int
  | Cfloat of float
  | Cstring of string
  | Cnil
  | Cinfinity


(* Define the types for binary operators *)
and binop =
  | Badd | Bsub | Bmul | Bdiv | Bmod
  | Beq | Bneq | Blt | Ble | Bgt | Bge
  | Band | Bor

and unop =
  | Uneg | Uplus

and stmt =
  | Sassign of expr * expr * bool option
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
  | Srandom of expr * expr
  | Serror of string
  | Scomment of string
