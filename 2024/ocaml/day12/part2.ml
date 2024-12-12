open Base
open Helpers
open Option

let parse_grid_cell grid cell c = Map.set grid ~key:cell ~data:c

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (parse_grid_row acc x row, x + 1)))

let same_section grid cell dir =
  Option.value ~default:false
    ( Map.find grid cell >>= fun c ->
      Map.find grid (cell_in_dir dir cell) >>= fun c' ->
      return (Char.equal c c') )

let wall_dir = function Left | Right -> Up | Up | Down -> Left

(* Is this cell the top-most/left-most cell of the wall on side of dir *)
let first_on_wall grid cell dir =
  (not (same_section grid cell (wall_dir dir))) (* convex *)
  || same_section grid (cell_in_dir (wall_dir dir) cell) dir (* concave *)

let rec dfs grid (seen, a, s) cell =
  if Set.mem seen cell then (seen, a, s)
  else
    List.fold dirs
      ~init:(Set.add seen cell, a + 1, s)
      ~f:(fun (seen, a, s) dir ->
        if same_section grid cell dir then
          dfs grid (seen, a, s) (cell_in_dir dir cell)
        else if first_on_wall grid cell dir then (seen, a, s + 1)
        else (seen, a, s))

let count_cell grid (seen, acc) cell =
  let seen', area, sides = dfs grid (seen, 0, 0) cell in
  (seen', acc + (area * sides))

let rec count_row grid n acc x y =
  if phys_equal y n then acc
  else count_row grid n (count_cell grid acc { x; y }) x (y + 1)

let rec count_grid grid n acc x =
  if phys_equal x n then acc
  else count_grid grid n (count_row grid n acc x 0) (x + 1)

let () =
  let lines = read_lines () in
  let n = List.length lines in
  let grid = parse_grid (Map.empty (module Coord)) lines in
  count_grid grid n (Set.empty (module Coord), 0) 0
  |> snd |> Stdio.printf "%d\n"
