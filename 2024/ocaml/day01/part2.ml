open Helpers

let parse_line s =
  match split_string "\\s+" s with
  | x :: y :: _ -> Some (int_of_string x, int_of_string y)
  | _ -> None

let unzip = List.fold_left (fun (xs, ys) (x, y) -> (x :: xs, y :: ys)) ([], [])

let get_or_default tbl default key =
  Option.value (Hashtbl.find_opt tbl key) ~default

let rec count =
  List.fold_left (fun acc x ->
      Hashtbl.add acc x (get_or_default acc 0 x + 1);
      acc)

let () =
  let l1, l2 = read_lines () |> List.filter_map parse_line |> unzip in
  let l2_count = count (Hashtbl.create 2000) l2 in
  let res =
    List.map (fun x -> x * get_or_default l2_count 0 x) l1
    |> List.fold_left ( + ) 0
  in
  Printf.printf "%d\n" res
