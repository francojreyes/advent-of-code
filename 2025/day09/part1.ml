open! Core

module IntPair = struct 
  module T = struct
    type t = int * int [@@deriving compare, equal, sexp]
  end

  include T
  include Comparable.Make_plain (T)
end

let parse_line line = 
  String.lsplit2 line ~on:',' |> Option.map ~f:(Tuple2.map ~f:Int.of_string)

let area (x, y) (x', y') = 
  (Int.abs (x - x') + 1) * (Int.abs (y - y') + 1)

let () =
  let points = 
    In_channel.input_lines In_channel.stdin
    |> List.filter_map ~f:parse_line
    |> Sequence.of_list
  in
  Sequence.cartesian_product points points
  |> Sequence.filter_map ~f:(fun (a, b) ->
    match IntPair.equal a b with
    | true -> None
    | false -> Some (area a b))
  |> Sequence.max_elt ~compare:Int.compare
  |> Option.value_exn
  |> Int.to_string
  |> print_endline