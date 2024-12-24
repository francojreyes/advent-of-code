open Base
open Helpers

module Edge = struct
  module T = struct
    type t = string * string [@@deriving compare, sexp]
  end

  include T
  include Comparator.Make (T)
end

let parse_line s =
  let a, b = String.lsplit2_exn ~on:'-' s in
  if String.compare a b < 0 then (a, b) else (b, a)

let pair_of_list (a, b) = [ a; b ]

let combinations3 lst =
  let rec aux3 a b acc = function
    | [] -> acc
    | c :: cs -> aux3 a b ((a, b, c) :: acc) cs
  in
  let rec aux2 a acc = function
    | [] | [ _ ] -> acc
    | b :: bs -> aux2 a (aux3 a b acc bs) bs
  in
  let rec aux1 acc = function
    | [] | [ _ ] | [ _; _ ] -> acc
    | a :: aas -> aux1 (aux2 a acc aas) aas
  in
  aux1 [] lst

let is_connected edges (a, b, c) =
  Set.mem edges (a, b) && Set.mem edges (b, c) && Set.mem edges (a, c)

let extend_clique edges nodes clique =
  let adjacent a b =
    if String.compare a b < 0 then Set.mem edges (a, b) else Set.mem edges (b, a)
  in
  let open Option.Let_syntax in
  let%bind d =
    List.find nodes ~f:(fun v -> List.for_all clique ~f:(adjacent v))
  in
  return (d :: clique)

let () =
  let edges = read_lines () |> List.map ~f:parse_line in
  let nodes =
    List.concat_map ~f:pair_of_list edges
    |> List.sort ~compare:String.compare
    |> List.remove_consecutive_duplicates ~equal:String.equal
  in
  let edges = Set.of_list (module Edge) edges in
  combinations3 nodes
  |> List.filter ~f:(is_connected edges)
  |> List.map ~f:(fun (a, b, c) -> [ a; b; c ])
  |> Fn.apply_n_times ~n:10 (List.filter_map ~f:(extend_clique edges nodes))
  |> List.hd_exn
  |> List.sort ~compare:String.compare
  |> String.concat ~sep:","
  |> Stdio.print_endline

(*

All nodes have same degree? (4 for small, 13 for big)
Regular graph
I'm just gonna guess and hope it's planar tbh
Ok just 'brute force' it

*)
