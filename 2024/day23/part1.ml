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
  if String.(a < b) then (a, b) else (b, a)

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

let is_t = String.is_prefix ~prefix:"t"
let is_t3 (a, b, c) = is_t a || is_t b || is_t c

let is_connected edges (a, b, c) =
  Set.mem edges (a, b) && Set.mem edges (b, c) && Set.mem edges (a, c)

let () =
  let edges = read_lines () |> List.map ~f:parse_line in
  let nodes =
    List.concat_map ~f:pair_of_list edges
    |> List.dedup_and_sort ~compare:String.compare
  in
  let edges = Set.of_list (module Edge) edges in
  combinations3 nodes
  |> List.count ~f:(fun set -> is_t3 set && is_connected edges set)
  |> Stdio.printf "%d\n"
