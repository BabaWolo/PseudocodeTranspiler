%{
  open Ast
%}


%token EOF
%token ADD SUB DIV MUL MOD
%token AND OR EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token <int> INT
%token LPAREN RPAREN

%start program
%type <Ast.command> program
%type <Ast.expr> expr

%left ADD SUB
%left MUL DIV MOD
%left AND OR
%nonassoc EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%%


program:
  | e = expr EOF { Cexpr e }
; 

expr:
  | e1 = INT { Ecst(Cint e1) }
  | e1 = expr o = binop e2 = expr { Ebinop(o, e1, e2) }
  | LPAREN e = expr RPAREN { e }
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

