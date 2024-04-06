(* Parser takes sequence of tokens as input (generated by Lexer) and determines if it conforms to the syntax rules defined by the grammar (CFG). *)
%{
  open Ast
%}

(* Menhir parser generator library and generates an OCaml module. *)
%token EOF
%token ADD SUB DIV MUL MOD
%token AND OR EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token <int> INT
%token <string> ID
%token <float> FLOAT
%token <string> STRING
%token LPAREN RPAREN LBRACE RBRACE COMMA DOT
%token LBRACKET RBRACKET
%token ASSIGN
%token NEWLINE
%token LET BE A NEW
%token IF ELSE PRINT FOR TO DOWNTO WHILE DO REPEAT UNTIL
%token BREAK CONTINUE
%token RETURN
%token EXCHANGE WITH
%token NIL

(* Type declarations tell the parser what type of value to produce for each non-terminal symbol in the grammar. *)
%start program
%type <Ast.command> program
%type <Ast.expr> expr 
%type <Ast.stmt> stmt suite
%type <Ast.ident> ident
%type <Ast.expr list> expr_list

(* Precedence and associativity declarations. Lines beneath has higher precedence level. *)
%left AND OR (* e.g. 'a AND b AND C' is parsed as '(a AND b) AND c', as operators are grouped from the left. *)
%left ADD SUB
%left MUL DIV MOD
%left EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%left NEWLINE
%left DOT

%% (* The separator marks the end of the declarations section and the beginning of the rules section. *)

program:
  | s = suite EOF { Cstmt s }
;

suite:
  | s = stmt { s }
  | NEWLINE s = suite { s }
  | s = stmt NEWLINE s1 = suite { Sblock [s; s1] }
;

stmt:
  | e1 = expr ASSIGN e2 = expr { Sassign(e1, e2)}
  | e1 = expr { Seval(e1) }
  | s = stmt NEWLINE { s }
  | IF e = expr LBRACE s = suite RBRACE { Sif(e, s, Sblock []) }
  | IF e = expr LBRACE s = suite RBRACE ELSE LBRACE s1 = suite RBRACE { Sif(e, s, s1) }
  | id = ident LPAREN p = expr_list RPAREN LBRACE s = suite RBRACE { Sdef(id, p, s) }
  | PRINT LPAREN e = expr RPAREN { Sprint(e) }
  | RETURN e = expr { Sreturn(e) }
  | FOR id = ident ASSIGN e1 = expr TO e2 = expr LBRACE s = suite RBRACE { Sfor(id, e1, e2, s, 1) }
  | FOR id = ident ASSIGN e1 = expr DOWNTO e2 = expr LBRACE s = suite RBRACE { Sfor(id, e1, e2, s, -1) }
  | LET id = ident BE A NEW list = ident { Snewlist(id, list) }
  | WHILE e = expr LBRACE s = suite RBRACE { Swhile(e, s) }
  | WHILE e = expr DO LBRACE s = suite RBRACE { Sdowhile(e, s) }
  | REPEAT LBRACE s = suite RBRACE UNTIL e = expr { Srepeat(e, s) }
  | BREAK { Sbreak }
  | CONTINUE { Scontinue }
  | EXCHANGE id1 = ident WITH id2 = ident { Sexchange(id1, id2) } (* The rule can be read as follows: When the parser encounters the EXCHANGE token, it expects to find an identifier (represented by id1 = ident). Then it expects the WITH token, followed by another identifier (id2 = ident). *)
;

expr_list:
  | /* empty */ { [] }
  | e = expr { [e] }
  | e = expr COMMA el = expr_list { e :: el }
;

expr:
  | e1 = INT { Ecst(Cint e1) }
  | e1 = FLOAT { Ecst(Cfloat e1) }
  | e1 = expr o = binop e2 = expr { Ebinop(o, e1, e2) }
  | LPAREN e = expr RPAREN { e }
  | LPAREN e1 = expr COMMA el = expr_list RPAREN { Etuple(e1 :: el) }
  | e1 = ident { Eident(e1) }
  | id = ident LPAREN p = expr_list RPAREN { Ecall(id, p)}
  | e1 = expr DOT e2 = ident { Eattribute(e1, e2) }
  | LBRACKET e = expr_list RBRACKET { Elist(e) }
  | id = ident LBRACKET e = expr RBRACKET { Eget(id, e) }
  | u = unop e = expr { Eunop(u, e) }
  | NIL { Ecst(Cnil) }
  | s = STRING { Ecst(Cstring s) }
;

ident:
  id = ID { { loc = ($startpos, $endpos); id } }
;

%inline binop:
  | ADD { Badd }
  | SUB { Bsub }
  | DIV { Bdiv }
  | MUL { Bmul }
  | MOD { Bmod }
  | AND { Band }
  | OR { Bor }
  | EQUAL { Beq }
  | NOTEQUAL { Bneq }
  | LESS { Blt }
  | LESSEQUAL { Ble }
  | GREATER { Bgt }
  | GREATEREQUAL { Bge }
;

%inline unop:
  | ADD { Uplus }
  | SUB { Uneg }

(* More about parser: 
The parser works by reading the input (source code) and trying to match it 
against the rules defined in the grammar. Each rule corresponds to a construct in the 
language (like an expression, a statement, a list of expressions, etc.).
When a rule is successfully matched, the parser executes the associated 
action (the code inside the curly braces {}). These actions typically 
construct nodes of the Abstract Syntax Tree (AST), which is a 
tree representation of the structure of the program. *)