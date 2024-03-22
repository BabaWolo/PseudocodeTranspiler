{
  open Parser
}

let digit = ['0'-'9']
let integer = '0' | ['1'-'9'] digit*
let space = ' ' | '\t'
let letter = ['a'-'z' 'A'-'Z']
let ident = (letter | '_') (letter | digit | '_')*

rule token = parse
  | "\n"    { Lexing.new_line lexbuf; NEWLINE} 
  | space { token lexbuf }
  | '+'     { ADD }
  | '-'     { SUB }
  | '*'     { MUL }
  | '/'     { DIV }
  | '%'     { MOD }
  | '('     { LPAREN }
  | ')'     { RPAREN }
  | "and"   { AND }
  | "or"    { OR }
  | "=="    { EQUAL }
  | "!="    { NOTEQUAL }
  | "<"     { LESS }
  | "<="    { LESSEQUAL }
  | ">"     { GREATER }
  | ">="    { GREATEREQUAL }
  | '='     { ASSIGN }
  | "if"    { IF }
  | '{'     { LBRACE }
  | '}'     { RBRACE }
  | "PRINT" { PRINT }
  | digit+  { INT(int_of_string (Lexing.lexeme lexbuf)) }
  | ident   { ID(Lexing.lexeme lexbuf) }
  | eof     { EOF }  
  | _ as c  { raise (Failure ("illegal character: " ^ Char.escaped c)) }

(* {
  open Parser
  (* exception Lexing_error of string *)
}

let digit = ['0'-'9']
let integer = '0' | ['1'-'9'] digit*
(* let letter = ['a'-'z' 'A'-'Z'] *)
(* let ident = (letter | '_') (letter | digit | '_')* *)
let space = ' ' | '\t'
(* let comment = "//" [^'\n']* '\n'    
let newLine = '\n' *)


rule token = parse 
   (*  | comment { Lexing.new_line lexbuf; token lexbuf } (* Single line comment *) *)
    | space { token lexbuf }
    | '+'     { PLUS }
    (* | '-'     { [MINUS] }
    | '*'     { [TIMES] }
    | "/"     { [DIV] }
    | '='     { [EQUAL] }
    | "=="    { [CMP Beq] }
    | "!="    { [CMP Bneq] }
    | "mod"   { [MOD] }
    | "<"     { [CMP Blt] }
    | "<="    { [CMP Ble] }
    | ">"     { [CMP Bgt] }
    | ">="    { [CMP Bge] }
    | '('     { [LP] } 
    | ')'     { [RP] }
    | '['     { [LSQ] }
    | ']'     { [RSQ] }
    | ','     { [COMMA] }
    | ':'     { [COLON] }
    | '\n'    { Lexing.new_line lexbuf; [NEWLINE] } *)
    (* | ident as id { ID(id) }     *)
    | digit+ { INT(int_of_string (Lexing.lexeme lexbuf)) }
    | eof           { EOF }   *)


(* 
let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = (letter | '_') (letter | digit | '_')*
let integer = '0' | ['1'-'9'] digit*
let space = ' ' | '\t'
let comment = "#" [^'\n']*

rule next_tokens = parse
  | '\n'    { new_line lexbuf; update_stack (indentation lexbuf) }
  | (space | comment)+
            { next_tokens lexbuf }
  | ident as id { [id_or_kwd id] }
  | '+'     { [PLUS] }
  | '-'     { [MINUS] }
  | '*'     { [TIMES] }
  | "//"    { [DIV] }
  | '%'     { [MOD] }
  | '='     { [EQUAL] }
  | "=="    { [CMP Beq] }
  | "!="    { [CMP Bneq] }
  | "<"     { [CMP Blt] }
  | "<="    { [CMP Ble] }
  | ">"     { [CMP Bgt] }
  | ">="    { [CMP Bge] }
  | '('     { [LP] }
  | ')'     { [RP] }
  | '['     { [LSQ] }
  | ']'     { [RSQ] }
  | ','     { [COMMA] }
  | ':'     { [COLON] }
  | integer as s
            { try [CST (Cint (Int64.of_string s))]
              with _ -> raise (Lexing_error ("constant too large: " ^ s)) }
  | '"'     { [CST (Cstring (string lexbuf))] }
  | eof     { NEWLINE :: unindent 0 @ [EOF] }
  | _ as c  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }

and indentation = parse
  | (space | comment)* '\n'
      { new_line lexbuf; indentation lexbuf }
  | space* as s
      { String.length s }

and string = parse
  | '"'
      { let s = Buffer.contents string_buffer in
	Buffer.reset string_buffer;
	s }
  | "\\n"
      { Buffer.add_char string_buffer '\n';
	string lexbuf }
  | "\\\""
      { Buffer.add_char string_buffer '"';
	string lexbuf }
  | _ as c
      { Buffer.add_char string_buffer c;
	string lexbuf }
  | eof
      { raise (Lexing_error "unterminated string") }

{

  let next_token =
    let tokens = Queue.create () in (* next tokens to emit *)
    fun lb ->
      if Queue.is_empty tokens then begin
	let l = next_tokens lb in
	List.iter (fun t -> Queue.add t tokens) l
      end;
      Queue.pop tokens
}
*)