open Base
open Helpers
open Option

let parse_grid_cell grid cell c =
  Map.set grid ~key:cell ~data:(Char.get_digit_exn c)

let parse_grid_row acc x row =
  String.fold ~init:(acc, 0)
    ~f:(fun (acc, y) c -> (parse_grid_cell acc { x; y } c, y + 1))
    row
  |> fst

let parse_grid acc =
  Fn.compose fst
    (List.fold ~init:(acc, 0) ~f:(fun (acc, x) row ->
         (parse_grid_row acc x row, x + 1)))

let can_move grid cell dir =
  Option.value ~default:false
    ( Map.find grid cell >>= fun l ->
      Map.find grid (cell_in_dir dir cell) >>= fun l' -> return (l' = l + 1) )

let rec reachable grid memo cell =
  match Map.find memo cell with
  | Some reach' -> (memo, reach')
  | None -> (
      match Map.find grid cell with
      | Some 9 -> (Map.set memo ~key:cell ~data:1, 1)
      | _ ->
          let memo', reach' =
            List.filter ~f:(can_move grid cell) dirs
            |> List.fold ~init:(memo, 0) ~f:(fun (memo, reach) dir ->
                   let memo', reach' =
                     reachable grid memo (cell_in_dir dir cell)
                   in
                   (memo', reach + reach'))
          in
          (Map.set memo' ~key:cell ~data:reach', reach'))

(* let print_entry (k, vs) =
   Stdio.printf "%d,%d: " (k.x + 1) (k.y + 1);
   Set.iter ~f:(fun c -> Stdio.printf "%d,%d " (c.x + 1) (c.y + 1)) vs;
   Stdio.printf "\n" *)

let count_cell grid (memo, acc) cell =
  match Map.find grid cell with
  | Some 0 ->
      let memo', reach = reachable grid memo cell in
      (memo', acc + reach)
  | _ -> (memo, acc)

let rec count_row grid n acc x y =
  if phys_equal y n then acc
  else count_row grid n (count_cell grid acc { x; y }) x (y + 1)

let rec count_grid grid n acc x =
  if phys_equal x n then acc
  else count_grid grid n (count_row grid n acc x 0) (x + 1)

let () =
  let lines = read_lines () in
  let n = List.length lines in
  let grid = parse_grid (Map.empty (module Coord)) lines in
  count_grid grid n (Map.empty (module Coord), 0) 0
  |> snd |> Stdio.printf "%d\n"
