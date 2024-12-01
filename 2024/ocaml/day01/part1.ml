open Helpers

let parse_line s =
  match split_string "\\s+" s with
  | x :: y :: _ -> Some (int_of_string x, int_of_string y)
  | _ -> None

let unzip = List.fold_left (fun (xs, ys) (x, y) -> (x :: xs, y :: ys)) ([], [])
let sum_diffs = List.fold_left2 (fun acc x y -> acc + abs (x - y)) 0

let () =
  let l1, l2 = read_lines () |> List.filter_map parse_line |> unzip in
  let res = sum_diffs (List.sort compare l1) (List.sort compare l2) in
  Printf.printf "%d\n" res
