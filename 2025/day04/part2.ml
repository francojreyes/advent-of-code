open! Core

module IntPair = struct 
  module T = struct
    type t = int * int [@@deriving compare, sexp]
  end

  include T
  include Comparable.Make_plain (T)
end

let parse_lines lines =
  List.foldi lines ~init:IntPair.Set.empty ~f:(fun i rolls line ->
    String.foldi line ~init:rolls ~f:(fun j rolls -> function
    | '@' -> Set.add rolls (i, j)
    | _ -> rolls))

let neighbours (i, j) =
  [ (i + 1, j)
  ; (i - 1, j)
  ; (i, j + 1)
  ; (i, j - 1)
  ; (i + 1, j + 1)
  ; (i - 1, j - 1)
  ; (i - 1, j + 1)
  ; (i + 1, j - 1) ]

let count_removable rolls =
  let rec loop rolls acc =
    let removed, remaining =
      Set.partition_tf rolls ~f:(fun roll ->
        neighbours roll |> List.count ~f:(Set.mem rolls) < 4)
    in
    match Set.length removed with
    | 0 -> acc
    | n -> loop remaining (acc + n)
  in
  loop rolls 0

let () =
  In_channel.input_lines In_channel.stdin
  |> parse_lines
  |> count_removable
  |> Int.to_string
  |> print_endline
