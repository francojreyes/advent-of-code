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

let rec dfs walls dist curr_dist cell =
  let valid cell = (not (Set.mem walls cell)) && not (Map.mem dist cell) in
  match neighbours cell |> List.filter ~f:valid |> List.hd with
  | None -> dist
  | Some next ->
      let next_dist = curr_dist + 1 in
      dfs walls (Map.set dist ~key:next ~data:next_dist) next_dist next

let distance a b = abs (a.x - b.x) + abs (a.y - b.y)

let cheats dists (s, sd) =
  Map.to_alist dists
  |> List.filter_map ~f:(fun (t, td) ->
         let d = distance s t in
         let saved = td - sd - d in
         if d <= 20 && saved > 0 then Some saved else None)

let none = { x = -1; y = -1 }

let () =
  let walls, src =
    read_lines () |> parse_grid (Set.empty (module Coord), none)
  in
  let dists = dfs walls (Map.singleton (module Coord) src 0) 0 src in
  Map.to_alist dists
  |> List.concat_map ~f:(cheats dists)
  |> List.count ~f:(fun x -> x >= 100)
  |> Stdio.printf "%d\n"
