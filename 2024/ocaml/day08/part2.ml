open Base
open Helpers

let parse_grid_cell grid cell = function
  | '.' -> grid
  | c ->
      Map.update grid c
        ~f:(Option.value_map ~default:[ cell ] ~f:(List.cons cell))

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc rows =
  List.fold ~init:(acc, 0)
    ~f:(fun (acc, x) row -> (parse_grid_row acc x row, x + 1))
    rows
  |> fst

let valid n { x; y } = x >= 0 && x < n && y >= 0 && y < n

let nodes_in_dir n dir cell =
  let rec go acc cell =
    if valid n cell then
      go (cell :: acc) { x = cell.x + dir.x; y = cell.y + dir.y }
    else acc
  in
  go [] cell

let antinodes n (c, c') =
  let dx = c.x - c'.x in
  let dy = c.y - c'.y in
  List.append
    (nodes_in_dir n { x = dx; y = dy } c)
    (nodes_in_dir n { x = -dx; y = -dy } c)

let unique_pairs lst =
  List.concat_mapi lst ~f:(fun i a ->
      List.mapi (List.drop lst (i + 1)) ~f:(fun _ b -> (a, b)))

let antinodes_of_freq n cs = unique_pairs cs |> List.concat_map ~f:(antinodes n)
let count_unique lst = Set.of_list (module Coord) lst |> Set.length

let () =
  let lines = read_lines () in
  let n = List.length lines in
  parse_grid (Map.empty (module Char)) lines
  |> Map.data
  |> List.concat_map ~f:(antinodes_of_freq n)
  |> count_unique |> Stdio.printf "%d\n"
