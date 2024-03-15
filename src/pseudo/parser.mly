%{
  open Ast
%}


%token EOF
%token PLUS
%token <int> INT

%start program
%type <Ast.command> program

%left PLUS
%%


program:
  | e = expr EOF { Cexpr e }
; 

expr:
  | n = INT { Ecst(Cint(n)) }
  | e1 = expr PLUS e2 = expr { Ebinop(Badd, e1, e2) }
;