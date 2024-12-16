open Base
open Helpers
open Option.Let_syntax

type entity = Wall | Box

let is_box = function Box -> true | _ -> false
let is_wall = function Wall -> true | _ -> false

let test_cell grid f coord =
  Map.find grid coord |> Option.value_map ~default:false ~f

let parse_grid_cell (grid, src) { x; y } c =
  let cell_l = { x; y = 2 * y } in
  let cell_r = { x; y = (2 * y) + 1 } in
  match c with
  | '@' -> (grid, cell_l)
  | '#' ->
      let grid' = Map.set grid ~key:cell_l ~data:Wall in
      (Map.set grid' ~key:cell_r ~data:Wall, src)
  | 'O' -> (Map.set grid ~key:cell_l ~data:Box, src)
  | _ -> (grid, src)

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (parse_grid_row acc x row, x + 1)))

let parse_dir c =
  match c with
  | '^' -> Some Up
  | 'v' -> Some Down
  | '<' -> Some Left
  | '>' -> Some Right
  | _ -> None

(* spaces that entity must move into *)
let box_dests coord dir =
  match dir with
  | Up | Down ->
      let coord' = cell_in_dir dir coord in
      [ coord'; cell_in_dir Right coord' ]
  | Right -> [ Fn.apply_n_times ~n:2 (cell_in_dir dir) coord ]
  | Left -> [ cell_in_dir dir coord ]

let potential_boxes coords =
  List.concat_map coords ~f:(fun coord -> [ coord; cell_in_dir Left coord ])
  |> List.sort ~compare:Coord.compare
  |> List.remove_consecutive_duplicates ~equal:Coord.equal

(*
  First check if spaces it must move to are not walls
  Find boxes in spaces it must move to (space or left), find any boxes and move those
  Move item
*)
let rec make_space grid coords dir =
  let%bind grid =
    if List.exists ~f:(test_cell grid is_wall) coords then None else Some grid
  in
  let boxes = List.filter ~f:(test_cell grid is_box) (potential_boxes coords) in
  List.fold ~init:(Some grid)
    ~f:(fun mgrid coord -> mgrid >>= fun grid -> move_box grid coord dir)
    boxes

and move_box grid coord dir =
  let%bind grid = make_space grid (box_dests coord dir) dir in
  let grid = Map.set grid ~key:(cell_in_dir dir coord) ~data:Box in
  return (Map.remove grid coord)

let move (grid, curr) dir =
  let next = cell_in_dir dir curr in
  match make_space grid [ next ] dir with
  | Some grid' ->  (grid', next)
  | None -> (grid, curr)

let () =
  let lines = read_lines () in
  let map, movements = List.split_while ~f:(Fn.non String.is_empty) lines in
  let init = parse_grid (Map.empty (module Coord), { x = -1; y = -1 }) map in
  List.concat_map
    ~f:(fun l -> String.to_list l |> List.filter_map ~f:parse_dir)
    movements
  |> List.fold ~init ~f:move |> fst
  |> Map.fold ~init:0 ~f:(fun ~key ~data acc ->
         acc + if is_box data then (100 * key.x) + key.y else 0)
  |> Stdio.printf "%d\n"
