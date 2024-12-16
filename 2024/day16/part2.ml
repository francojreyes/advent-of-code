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
    type t = coord * dir [@@deriving equal, compare, sexp]
  end

  include T
  include Comparator.Make (T)
end

type state = { dist : int; pred : CoordDir.t list }

let fst3 (a, _, _) = a

let find_and_extract_min = function
  | [] -> None
  | hd :: _ as lst ->
      let min_elem =
        List.fold lst ~init:hd ~f:(fun acc x ->
            if fst3 x < fst3 acc then x else acc)
      in
      let rec remove_one lst =
        match lst with
        | [] -> []
        | x :: xs -> if fst3 x = fst3 min_elem then xs else x :: remove_one xs
      in
      Some (min_elem, remove_one lst)

let neighbours (d, (coord, dir), _) =
  [
    (d + 1, (cell_in_dir dir coord, dir), (coord, dir));
    (d + 1000, (coord, next_dir dir), (coord, dir));
    (d + 1000, (coord, prev_dir dir), (coord, dir));
  ]

let update d p = function
  | None -> { dist = d; pred = [ p ] }
  | Some { dist; pred } ->
      if d < dist then { dist = d; pred = [ p ] }
      else if d = dist then { dist; pred = p :: pred }
      else { dist; pred }

let valid grid state (d, el, _) =
  (not (Set.mem grid (fst el)))
  &&
  match Map.find state el with
  | Some { dist; pred = _ } -> d <= dist
  | None -> true

let rec dijkstra grid state q =
  match find_and_extract_min q with
  | None -> state
  | Some (min_elem, q) ->
      let d, curr, prev = min_elem in
      let state = Map.update state curr ~f:(update d prev) in
      let q = List.filter ~f:(valid grid state) (neighbours min_elem) @ q in
      dijkstra grid state q

let rec all_pred state acc curr =
  if Set.mem acc curr then acc
  else
    let acc = Set.add acc curr in
    match Map.find state curr with
    | None -> acc
    | Some { dist = _; pred = [ p ] } when CoordDir.equal p curr -> acc
    | Some { dist = _; pred } ->
        List.fold ~init:acc ~f:(fun acc -> all_pred state acc) pred

(* let nx = 17
let ny = 17
let rec print { x; y } grid best =
  if y >= ny then (
    Stdio.printf "\n";
    if x >= nx-1 then () else print { x = x + 1; y = 0 } grid best)
  else
    (Stdio.printf
      (if Set.mem best {x;y} then "O"
      else if Set.mem grid {x;y} then "#"
      else ".");
  print { x = x; y = y + 1 } grid best) *)

let list_min ~key lst =
  List.fold ~init:(List.hd_exn lst) ~f:(fun acc x -> if key x < key acc then x else acc) lst

let min_only ~key lst =
  let min_el = list_min ~key lst in
  List.filter lst ~f:(fun x -> key x = key min_el)

let () =
  let lines = read_lines () in
  let init =
    (Set.empty (module Coord), { x = -1; y = -1 }, { x = -1; y = -1 })
  in
  let grid, src, exit = parse_grid init lines in
  let state =
    dijkstra grid
      (Map.empty (module CoordDir))
      [ (0, (src, Right), (src, Right)) ]
  in
  List.map ~f:(fun dir -> (exit, dir)) dirs
  |> min_only ~key:(fun x -> Option.value_map ~default:100000 ~f:(fun {dist;pred=_} -> dist) (Map.find state x))
  |> List.fold ~init:(Set.empty (module CoordDir)) ~f:(all_pred state)
  |> Set.map (module Coord) ~f:fst
  (* |> print {x=0;y=0} grid *)
  (* |> Set.iter ~f:(fun c -> Stdio.printf "%s\n" (Sexp.to_string (Coord.sexp_of_t c))) *)
  |> Set.length |> Stdio.printf "%d\n"
