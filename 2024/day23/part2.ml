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
let adj edges v u = Set.mem edges (u, v)

let maximum_clique edges nodes =
  let rec aux best acc = function
    | [] ->
        let s = List.rev acc |> String.concat ~sep:"," in
        if String.length s > String.length best then s else best
    | v :: vs ->
        let best' =
          if List.for_all ~f:(adj edges v) acc then aux best (v :: acc) vs
          else best
        in
        aux best' acc vs
  in
  aux "" [] nodes

let () =
  let edges = read_lines () |> List.map ~f:parse_line in
  let nodes =
    List.concat_map ~f:pair_of_list edges
    |> List.sort ~compare:String.compare
    |> List.remove_consecutive_duplicates ~equal:String.equal
  in
  let edges = Set.of_list (module Edge) edges in
  maximum_clique edges nodes |> Stdio.print_endline

(*

All nodes have same degree? (4 for small, 13 for big)
Regular graph
I'm just gonna guess and hope it's planar tbh
Ok just 'brute force' it

*)
