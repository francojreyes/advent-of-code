open Base
open Helpers

let n = 70

let parse_line line =
  let open Option.Let_syntax in
  let%bind x, y = String.lsplit2 ~on:',' line in
  let%bind x = Int.of_string_opt x in
  let%bind y = Int.of_string_opt y in
  return { x; y }

let neighbours cell = List.map ~f:(fun d -> cell_in_dir d cell) dirs

let valid seen { x; y } =
  x >= 0 && x <= n && y >= 0 && y <= n && not (Set.mem seen { x; y })

let rec dfs seen = function
  | [] -> false
  | { x; y } :: q ->
      if x = n && y = n then true
      else
        let next = neighbours { x; y } |> List.filter ~f:(valid seen) in
        let seen' = List.fold ~init:seen ~f:Set.add next in
        let q' = next @ q in
        dfs seen' q'

let src = { x = 0; y = 0 }

let () =
  read_lines ()
  |> List.filter_map ~f:parse_line
  |> List.fold_until
       ~init:(Set.empty (module Coord))
       ~f:(fun s c ->
         let s' = Set.add s c in
         if dfs s' [ src ] then Continue s' else Stop c)
       ~finish:(Fn.const src)
  |> fun { x; y } -> Stdio.printf "%d,%d\n" x y

(*
Register A: 61657405
Register B: 0
Register C: 0

Program: 2,4,1,2,7,5,4,3,0,3,1,7,5,5,3,0


  *)
