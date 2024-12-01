open Base
open Helpers

let parse_line s =
  match split_string "\\s+" s with
  | x :: y :: _ -> Some (Int.of_string x, Int.of_string y)
  | _ -> None

let unzip =
  List.fold ~init:([], []) ~f:(fun (xs, ys) (x, y) -> (x :: xs, y :: ys))

let get_or_default tbl default key =
  Option.value (Hashtbl.find tbl key) ~default

let count tbl =
  List.fold_left
    ~f:(fun acc x ->
      Hashtbl.set acc ~key:x ~data:(get_or_default acc 0 x + 1);
      acc)
    ~init:tbl

let () =
  let l1, l2 = read_lines () |> List.filter_map ~f:parse_line |> unzip in
  let l2_count = count (Hashtbl.create (module Int)) l2 in
  let res =
    List.map ~f:(fun x -> x * get_or_default l2_count 0 x) l1
    |> List.fold_left ~f:( + ) ~init:0
  in
  Stdio.printf "%d\n" res
