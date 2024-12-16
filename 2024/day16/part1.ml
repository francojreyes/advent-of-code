open Base
open Helpers

let parse_grid_cell (walls, src, exit) cell c =
  match c with
  | '#' -> (Set.add walls cell, src, exit)
  | 'S' -> (walls, cell, exit)
  | 'E' -> (walls, src, cell)
  | _ -> (walls, src, exit)

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (parse_grid_row acc x row, x + 1)))

let next_dir dir =
  match dir with Up -> Right | Right -> Down | Down -> Left | Left -> Up

module CoordDir = struct
  module T = struct
    type t = coord * dir [@@deriving compare, sexp]
  end

  include T
  include Comparator.Make (T)
end

let find_and_extract_min = function
  | [] -> None
  | hd :: _ as lst ->
      let min_elem =
        List.fold lst ~init:hd ~f:(fun acc x ->
            if fst x < fst acc then x else acc)
      in
      let rec remove_one lst =
        match lst with
        | [] -> []
        | x :: xs -> if fst x = fst min_elem then xs else x :: remove_one xs
      in
      Some (min_elem, remove_one lst)

let neighbours (d, (coord, dir)) =
  [
    (d + 1, (cell_in_dir dir coord, dir));
    (d + 1000, (coord, next_dir dir));
    (d + 1000, (coord, prev_dir dir));
  ]

let rec dijkstra grid dist q =
  match find_and_extract_min q with
  | None -> dist
  | Some (min_elem, q) ->
      let dist = Map.set dist ~key:(snd min_elem) ~data:(fst min_elem) in
      let q =
        List.filter
          ~f:(fun (_, el) -> not (Set.mem grid (fst el) || Map.mem dist el))
          (neighbours min_elem)
        @ q
      in
      dijkstra grid dist q

let () =
  let lines = read_lines () in
  let init =
    (Set.empty (module Coord), { x = -1; y = -1 }, { x = -1; y = -1 })
  in
  let grid, src, exit = parse_grid init lines in
  let dist =
    dijkstra grid (Map.empty (module CoordDir)) [ (0, (src, Right)) ]
  in
  List.filter_map ~f:(fun dir -> Map.find dist (exit, dir)) dirs
  |> List.iter ~f:(Stdio.printf "%d\n")
