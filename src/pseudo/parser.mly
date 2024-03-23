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
  | s = stmt NEWLINE s1 = suite { Sblock [s; s1] }
;

stmt:
  | e1 = ident ASSIGN e = expr { Sassign(e1, e)}
  | e1 = expr { Seval(e1) }
  | s = stmt NEWLINE { s }
  | IF LPAREN e = expr RPAREN LBRACE s = suite RBRACE { Sif(e, s, Sblock []) }
  | IF LPAREN e = expr RPAREN LBRACE s = suite RBRACE ELSE LBRACE s1 = suite RBRACE { Sif(e, s, s1) }
  | PRINT LPAREN e = expr RPAREN { Sprint(e) }
  | id = ident LPAREN p = separated_list(COMMA, expr) RPAREN LBRACE s = suite RBRACE { Sdef(id, p, s) }
  | id = ident LPAREN p = separated_list(COMMA, expr) RPAREN { Scall(id, p)}
  | RETURN e = expr { Sreturn(e) }
;


expr:
  | e1 = INT { Ecst(Cint e1) }
  | e1 = expr o = binop e2 = expr { Ebinop(o, e1, e2) }
  | LPAREN e = expr RPAREN { e }
  | e1 = ident { Eident(e1) }
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
