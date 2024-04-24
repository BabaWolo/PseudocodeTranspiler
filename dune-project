(lang dune 3.5)
(name "Pseudocode")
(version 1.0)
(using menhir 2.0)

(package
 (name Pseudocode)
 (synopsis "A simple pseudocode language")
 (description "A simple pseudocode language")
 (depends ocaml dune menhir ounit2)
 (allow_empty)
)
