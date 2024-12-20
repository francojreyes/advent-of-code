open Base
open Helpers

let n = 70
let nbytes = 1024

let parse_line line =
  let open Option.Let_syntax in
  let%bind x, y = String.lsplit2 ~on:',' line in
  let%bind x = Int.of_string_opt x in
  let%bind y = Int.of_string_opt y in
  return { x; y }

let neighbours cell = List.map ~f:(fun d -> cell_in_dir d cell) dirs

let valid seen { x; y } =
  x >= 0 && x <= n && y >= 0 && y <= n && not (Set.mem seen { x; y })

let rec bfs seen q =
  let open Option.Let_syntax in
  let%bind (d, { x; y }), q = Queue.pop q in
  if x = n && y = n then return d
  else
    let next = neighbours { x; y } |> List.filter ~f:(valid seen) in
    let seen' = List.fold ~init:seen ~f:Set.add next in
    let q' = List.fold ~init:q ~f:(fun q c -> Queue.push q (d + 1, c)) next in
    bfs seen' q'

let src = { x = 0; y = 0 }

let () =
  let corrupted =
    read_lines ()
    |> (Fn.flip List.take) nbytes
    |> List.filter_map ~f:parse_line
    |> Set.of_list (module Coord)
  in
  bfs (Set.add corrupted src) (Queue.singleton (0, src))
  |> Option.sexp_of_t Int.sexp_of_t
  |> Sexp.to_string |> Stdio.printf "%s\n"
