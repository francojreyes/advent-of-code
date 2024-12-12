open Base
open Helpers

let parse_grid_cell (grid, src) cell c =
  ( Map.set grid ~key:cell ~data:(Char.equal c '#'),
    if Char.equal c '^' then cell else src )

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (parse_grid_row acc x row, x + 1)))

type dir = Up | Right | Down | Left

let next_dir dir =
  match dir with Up -> Right | Right -> Down | Down -> Left | Left -> Up

let cell_in_dir dir { x; y } =
  match dir with
  | Up -> { x = x - 1; y }
  | Right -> { x; y = y + 1 }
  | Down -> { x = x + 1; y }
  | Left -> { x; y = y - 1 }

let rec explore grid seen cell dir =
  let cell' = cell_in_dir dir cell in
  match Map.find grid cell' with
  | Some true -> explore grid seen cell (next_dir dir)
  | Some false -> explore grid (Set.add seen cell') cell' dir
  | None -> seen

let () =
  let lines = read_lines () in
  let grid, src =
    parse_grid (Map.empty (module Coord), { x = -1; y = -1 }) lines
  in
  explore grid (Set.of_list (module Coord) [ src ]) src Up
  |> Set.length |> Stdio.printf "%d\n"
