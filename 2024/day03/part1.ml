open Base
open Helpers

let eval_mul m =
  find_all_matches "\\d+" m |> List.map ~f:Int.of_string
  |> List.fold ~init:1 ~f:( * )

let () =
  read_lines ()
  |> List.concat_map ~f:(find_all_matches "mul\\(\\d+,\\d+\\)")
  |> List.map ~f:eval_mul |> List.fold ~init:0 ~f:( + ) |> Stdio.printf "%d\n"
