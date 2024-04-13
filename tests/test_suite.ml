open OUnit2

(* Run all tests *)
let () =
  let suite =
    "All Tests">:::
      [ Arithmetic_parser_test.suite;
        (* Add other test suites here *)
      ]
  in
  run_test_tt_main suite
