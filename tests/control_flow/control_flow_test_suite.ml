open OUnit2

(* This kind of file should have a unique file name for each folder *)
(* This ensures that the test suite can be run from the root directory without conflicts *)
(* Add all arithmetic tests to the suite *)

let suite =
  "Control Flow Suite" >::: [
      Parser_test.suite;
      (* For_loops_test.suite; *)
    ]