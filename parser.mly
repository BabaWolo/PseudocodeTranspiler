{
  open Ast

}


%token EOF

%start program

%type <Ast.program> program

%%

%inline binop:
| PLUS  { Badd }
| MINUS { Bsub }
| TIMES { Bmul }
| DIV   { Bdiv }
| MOD   { Bmod }
| c=CMP { c    }
| AND   { Band }
| OR    { Bor  }
;

program:
  | EOF { Ast.Program [] }
  | stmt program { Ast.Program ($1 :: $2) }

stmt:
  | "print" expr ";" { Ast.Print $2 }
  | "let" ID "=" expr ";" { Ast.Let ($2, $4) }

expr:
  | INT { Ast.Int $1 }
  | ID { Ast.Id $1 }
  | expr "+" expr { Ast.Add ($1, $3) }
  | expr "-" expr { Ast.Sub ($1, $3) }
  | expr "*" expr { Ast.Mul ($1, $3) }
  | expr "/" expr { Ast.Div ($1, $3) }
  | "(" expr ")" { $2 }



