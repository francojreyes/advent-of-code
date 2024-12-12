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

let antinodes (c, c') =
  let dx = c.x - c'.x in
  let dy = c.y - c'.y in
  [ { x = c.x + dx; y = c.y + dy }; { x = c'.x - dx; y = c'.y - dy } ]

let unique_pairs lst =
  List.concat_mapi lst ~f:(fun i a ->
      List.mapi (List.drop lst (i + 1)) ~f:(fun _ b -> (a, b)))

let antinodes_of_freq cs = unique_pairs cs |> List.concat_map ~f:antinodes
let valid n { x; y } = x >= 0 && x < n && y >= 0 && y < n
let count_unique lst = Set.of_list (module Coord) lst |> Set.length

let () =
  let lines = read_lines () in
  let n = List.length lines in
  parse_grid (Map.empty (module Char)) lines
  |> Map.data
  |> List.concat_map ~f:antinodes_of_freq
  |> List.filter ~f:(valid n)
  |> count_unique |> Stdio.printf "%d\n"
