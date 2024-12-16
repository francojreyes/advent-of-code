open Base
open Helpers

type item = Wall | Box

let is_box = function Box -> true | _ -> false

let parse_grid_cell (grid, src) cell c =
  match c with
  | '@' -> (grid, cell)
  | '#' -> (Map.set grid ~key:cell ~data:Wall, src)
  | 'O' -> (Map.set grid ~key:cell ~data:Box, src)
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

let rec make_space grid coord dir =
  let coord' = cell_in_dir dir coord in
  match Map.find grid coord with
  | Some Wall -> None
  | Some Box ->
      let open Option.Let_syntax in
      let%bind grid' = make_space grid coord' dir in
      let grid'' = Map.set grid' ~key:coord' ~data:Box in
      return (Map.remove grid'' coord)
  | _ -> Some grid

(* let nx = 8
   let ny = 8

   let rec print { x; y } grid =
     if y >= ny then (
       Stdio.printf "\n";
       if x >= nx-1 then () else print { x = x + 1; y = 0 } grid)
     else
       (Stdio.printf
         (match Map.find grid { x; y } with
         | Some Wall -> "#"
         | Some Box -> "O"
         | Some Robot -> "@"
         | None -> ".");
     print { x = x; y = y + 1 } grid) *)

let move (grid, curr) dir =
  let next = cell_in_dir dir curr in
  match make_space grid next dir with
  | Some grid' -> (grid', next)
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
