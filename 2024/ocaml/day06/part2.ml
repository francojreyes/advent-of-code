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

type dir = Up | Right | Down | Left [@@deriving compare, sexp]

let next_dir dir =
  match dir with Up -> Right | Right -> Down | Down -> Left | Left -> Up

let cell_in_dir dir { x; y } =
  match dir with
  | Up -> { x = x - 1; y }
  | Right -> { x; y = y + 1 }
  | Down -> { x = x + 1; y }
  | Left -> { x; y = y - 1 }

module CoordDir = struct
  module T = struct
    type t = coord * dir [@@deriving compare, sexp]
  end

  include T
  include Comparator.Make (T)
end

let rec trapped grid seen cell dir =
  if Set.mem seen (cell, dir) then true
  else
    let seen' = Set.add seen (cell, dir) in
    let cell' = cell_in_dir dir cell in
    match Map.find grid cell' with
    | Some true -> trapped grid seen' cell (next_dir dir)
    | Some false -> trapped grid seen' cell' dir
    | None -> false

let () =
  let lines = read_lines () in
  let grid, src =
    parse_grid (Map.empty (module Coord), { x = -1; y = -1 }) lines
  in
  Map.counti grid ~f:(fun ~key ~data ->
      (not data)
      && trapped
           (Map.set grid ~key ~data:true)
           (Set.empty (module CoordDir))
           src Up)
  |> Stdio.printf "%d\n"
