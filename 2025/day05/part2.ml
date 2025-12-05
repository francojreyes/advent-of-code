open! Core

module IntPair = struct 
  module T = struct
    type t = int * int [@@deriving compare, sexp]
  end

  include T
  include Comparable.Make_plain (T)
end

let parse_range line =
  String.lsplit2 line ~on:'-' |> Option.map ~f:(Tuple2.map ~f:Int.of_string)

let insert_range ranges (lo, hi) =
  let overlapping, disjoint =
    Set.partition_tf ranges ~f:(fun (lo', hi') ->
      lo' <= hi + 1 && hi' >= lo - 1)
  in
  let lo = 
    Set.min_elt overlapping
    |> Option.value_map ~f:(Fn.compose (Int.min lo) fst) ~default:lo
  in
  let hi = 
    Set.max_elt overlapping
    |> Option.value_map ~f:(Fn.compose (Int.max hi) snd) ~default:hi
  in
  Set.add disjoint (lo, hi)

let () =
  In_channel.input_lines In_channel.stdin
  |> List.filter_map ~f:parse_range
  |> List.fold ~init:IntPair.Set.empty ~f:insert_range
  |> Set.sum (module Int) ~f:(fun (lo, hi) -> hi - lo + 1)
  |> Int.to_string
  |> print_endline
