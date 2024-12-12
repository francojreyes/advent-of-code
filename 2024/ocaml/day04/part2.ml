open Base
open Helpers

let make_board_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (Map.set acc ~key:{ x; y } ~data:c, y + 1))
    row
  |> fst

let make_board acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (make_board_row acc x row, x + 1)))

let mas = [ 'M'; 'A'; 'S' ]
let sam = [ 'S'; 'A'; 'M' ]

let rec check_dir board { x; y } goal (dx, dy) =
  match goal with
  | c :: cs -> (
      match Map.find board { x; y } with
      | Some c' when Char.equal c' c ->
          check_dir board { x = x + dx; y = y + dy } cs (dx, dy)
      | _ -> false)
  | _ -> true

let count_xmas_cell board { x; y } =
  if
    (check_dir board { x = x - 1; y = y - 1 } mas (1, 1)
    || check_dir board { x = x - 1; y = y - 1 } sam (1, 1))
    && (check_dir board { x = x - 1; y = y + 1 } mas (1, -1)
       || check_dir board { x = x - 1; y = y + 1 } sam (1, -1))
  then 1
  else 0

let rec count_xmas_row board n x y =
  if phys_equal y n then 0
  else count_xmas_cell board { x; y } + count_xmas_row board n x (y + 1)

let rec count_xmas board n x =
  if phys_equal x n then 0
  else count_xmas_row board n x 0 + count_xmas board n (x + 1)

let () =
  let lines = read_lines () in
  let n = List.length lines in
  let board = make_board (Map.empty (module Coord)) lines in
  count_xmas board n 0 |> Stdio.printf "%d\n"
