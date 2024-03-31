%{
  open Ast
%}


%token EOF
%token ADD SUB DIV MUL MOD
%token AND OR EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token <int> INT
%token <string> ID
%token <float> FLOAT
%token LPAREN RPAREN LBRACE RBRACE COMMA DOT
%token LBRACKET RBRACKET
%token ASSIGN
%token NEWLINE
%token IF ELSE PRINT FOR TO DOWNTO
%token RETURN

%start program
%type <Ast.command> program
%type <Ast.expr> expr
%type <Ast.stmt> stmt suite
%type <Ast.ident> ident

%left ADD SUB
%left MUL DIV MOD
%left AND OR
%left EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%%

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
  | id = ident LBRACKET index = expr RBRACKET ASSIGN e = expr { Sset(id, index, e) }
  | e1 = expr { Seval(e1) }
  | s = stmt NEWLINE { s }
  | IF e = expr LBRACE s = suite RBRACE { Sif(e, s, Sblock []) }
  | IF e = expr LBRACE s = suite RBRACE ELSE LBRACE s1 = suite RBRACE { Sif(e, s, s1) }
  | PRINT LPAREN e = expr RPAREN { Sprint(e) }
  | id = ident LPAREN p = params RPAREN LBRACE s = suite RBRACE { Sdef(id, p, s) }
  | RETURN e = expr { Sreturn(e) }
  | FOR id = ident ASSIGN e1 = expr TO e2 = expr LBRACE s = suite RBRACE { Sfor(id, e1, e2, s, 1) }
  | FOR id = ident ASSIGN e1 = expr DOWNTO e2 = expr LBRACE s = suite RBRACE { Sfor(id, e1, e2, s, -1) }
;

params:
  | /* empty */ { [] }
  | id = ident { [id] }
  | id = ident COMMA p = params { id :: p }
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
  | e1 = ident { Eident(e1) }
  | id = ident LPAREN p = expr_list RPAREN { Ecall(id, p)}
  | e1 = expr DOT e2 = ident { Eattribute(e1, e2) }
  | LBRACKET e = expr_list RBRACKET { Elist(e) }
  | id = ident LBRACKET e = expr RBRACKET { Eget(id, e) }
  | u = unop e = expr { Eunop(u, e) }
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
