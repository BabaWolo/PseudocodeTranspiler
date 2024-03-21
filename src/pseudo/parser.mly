%{
  open Ast
%}


%token EOF
%token ADD SUB DIV MUL MOD
%token AND OR EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token <int> INT
%token <string> ID
%token LPAREN RPAREN
%token ASSIGN
%token NEWLINE
%token IF LBRACE RBRACE

%start program
%type <Ast.command> program
%type <Ast.expr> expr
%type <Ast.stmt> stmt

%left ADD SUB
%left MUL DIV MOD
%left AND OR
%nonassoc EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%%



program:
  | s = stmts EOF { Cstmts s }
;

stmts:
  | s1 = stmt NEWLINE s = stmts { s1 :: s }
  | s1 = stmt NEWLINE { [s1] }
  | s1 = stmt EOF { [s1] }
;

stmt:
  | e1 = ID ASSIGN e = expr { Sassign(e1, e)}
  | e1 = expr { Seval(e1) }
  | IF LPAREN e = expr RPAREN LBRACE s = stmts RBRACE { Sif(e, s) }
;


expr:
  | e1 = INT { Ecst(Cint e1) }
  | e1 = expr ADD e2 = expr { Ebinop(Badd, e1, e2) }
  | e1 = expr SUB e2 = expr { Ebinop(Bsub, e1, e2) }
  | e1 = expr DIV e2 = expr { Ebinop(Bdiv, e1, e2) }
  | e1 = expr MUL e2 = expr { Ebinop(Bmul, e1, e2) }
  | e1 = expr MOD e2 = expr { Ebinop(Bmod, e1, e2) }
  | e1 = expr AND e2 = expr { Ebinop(Band, e1, e2) }
  | e1 = expr OR e2 = expr { Ebinop(Bor, e1, e2) }
  | e1 = expr EQUAL e2 = expr { Ebinop(Beq, e1, e2) }
  | e1 = expr NOTEQUAL e2 = expr { Ebinop(Bneq, e1, e2) }
  | e1 = expr LESS e2 = expr { Ebinop(Blt, e1, e2) }
  | e1 = expr LESSEQUAL e2 = expr { Ebinop(Ble, e1, e2) }
  | e1 = expr GREATER e2 = expr { Ebinop(Bgt, e1, e2) }
  | e1 = expr GREATEREQUAL e2 = expr { Ebinop(Bge, e1, e2) }
  | LPAREN e = expr RPAREN { e }
  | e1 = ID { Eident(e1) }
;