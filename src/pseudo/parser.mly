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
%token IF LBRACE RBRACE PRINT

%start program
%type <Ast.command> program
%type <Ast.expr> expr
%type <Ast.stmt> stmt

%left ADD SUB
%left MUL DIV MOD
%left AND OR
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
  | PRINT LPAREN e = expr RPAREN { Sprint(e) }
;


expr:
  | e1 = INT { Ecst(Cint e1) }
  | e1 = expr o = binop e2 = expr { Ebinop(o, e1, e2) }
  | LPAREN e = expr RPAREN { e }
  | e1 = ID { Eident(e1) }
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
