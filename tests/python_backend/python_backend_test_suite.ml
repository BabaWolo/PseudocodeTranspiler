open OUnit2

(* This kind of file should have a unique file name for each folder *)
(* This ensures that the test suite can be run from the root directory without conflicts *)
(* Add all arithmetic tests to the suite *)

let suite =
  "Python Backend Suite" >::: [
      Python_backend_test.suite;
    ]