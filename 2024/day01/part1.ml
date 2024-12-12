open Base
open Helpers

let parse_line s =
  match split_string "\\s+" s with
  | x :: y :: _ -> Some (Int.of_string x, Int.of_string y)
  | _ -> None

let sum_diffs = List.fold2_exn ~init:0 ~f:(fun acc x y -> acc + abs (x - y))

let () =
  let l1, l2 = read_lines () |> List.filter_map ~f:parse_line |> List.unzip in
  let res = sum_diffs (List.sort ~compare l1) (List.sort ~compare l2) in
  Stdio.printf "%d\n" res
