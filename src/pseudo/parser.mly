%{
  open Ast
%}


%token EOF
%token ADD SUB DIV MUL MOD
%token AND OR EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token <int> INT
%token <string> ID
%token LPAREN RPAREN LBRACE RBRACE COMMA
%token ASSIGN
%token NEWLINE
%token IF ELSE PRINT
%token RETURN DEF

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
  | s = stmt NEWLINE s1 = suite { Sblock [s; s1] }
;

stmt:
  | e1 = ident ASSIGN e = expr { Sassign(e1, e)}
  | e1 = expr { Seval(e1) }
  | s = stmt NEWLINE { s }
  | IF LPAREN e = expr RPAREN LBRACE s = suite RBRACE { Sif(e, s, Sblock []) }
  | IF LPAREN e = expr RPAREN LBRACE s = suite RBRACE ELSE LBRACE s1 = suite RBRACE { Sif(e, s, s1) }
  | PRINT LPAREN e = expr RPAREN { Sprint(e) }
  | id = ident LPAREN p = params RPAREN LBRACE s = suite RBRACE { Sdef(id, p, s) }
  | RETURN e = expr { Sreturn(e) }
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
  | e1 = expr o = binop e2 = expr { Ebinop(o, e1, e2) }
  | LPAREN e = expr RPAREN { e }
  | e1 = ident { Eident(e1) }
  | id = ident LPAREN p = expr_list RPAREN { Ecall(id, p)}
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
