%{
  open Ast
%}


%token EOF
%token PLUS
%token <int> INT

%start program
%type <Ast.command> program
%type <Ast.constant> const

%left PLUS
%%


program:
  | e = expr EOF { Cexpr e }
; 

expr:
  | e1 = const PLUS e2 = const { Ebinop(Badd, e1, e2) }
;

const:
  | n = INT { Cint(n) }