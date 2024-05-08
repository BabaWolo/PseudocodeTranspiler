open OUnit2

let suite =
  "Lexer Suite" >::: [
      Token_test.suite;
    ]