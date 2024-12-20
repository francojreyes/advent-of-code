open Base
open Helpers

let parse_grid_cell (walls, src) cell c =
  match c with
  | '#' -> (Set.add walls cell, src)
  | 'S' -> (walls, cell)
  | _ -> (walls, src)

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (parse_grid_row acc x row, x + 1)))

let neighbours cell = List.map ~f:(fun d -> cell_in_dir d cell) dirs

let cheat_dests cell =
  List.map ~f:(fun d -> cell_in_dir d (cell_in_dir d cell)) dirs

let rec dfs walls dist curr_dist cell =
  let valid cell = (not (Set.mem walls cell)) && not (Map.mem dist cell) in
  match neighbours cell |> List.filter ~f:valid |> List.hd with
  | None -> dist
  | Some next ->
      let next_dist = curr_dist + 1 in
      dfs walls (Map.set dist ~key:next ~data:next_dist) next_dist next

let time_saved dists (s, t) =
  let open Option.Let_syntax in
  let%bind sd = Map.find dists s in
  let%bind td = Map.find dists t in
  let res = td - sd - 2 in
  if res <= 0 then None else return res

let none = { x = -1; y = -1 }

let () =
  let walls, src =
    read_lines () |> parse_grid (Set.empty (module Coord), none)
  in
  let dists = dfs walls (Map.singleton (module Coord) src 0) 0 src in
  Map.keys dists
  |> List.concat_map ~f:(fun s -> List.map ~f:(fun t -> (s, t)) (cheat_dests s))
  |> List.filter_map ~f:(time_saved dists)
  |> List.count ~f:(fun x -> x >= 100)
  |> Stdio.printf "%d\n"
