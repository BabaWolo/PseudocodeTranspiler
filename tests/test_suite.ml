open OUnit2
open Arithmetic_tests
open Control_flow_tests
open Python_backend_tests
open Lexer_tests


(* Run a single test *)

(* Run all tests *)
let () =
  let suite =
    "All Tests">:::
      [ Arithmetic_test_suite.suite;
        Control_flow_test_suite.suite;
        Python_backend_test_suite.suite;
        Lexer_test_suite.suite;
        (* Add other test suites here *)
      ]
  in
  run_test_tt_main suite
