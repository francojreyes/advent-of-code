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
  ; (i + 1, j - 1)]

let () =
  let rolls = In_channel.input_lines In_channel.stdin |> parse_lines in
  Set.count rolls ~f:(fun roll ->
    (neighbours roll |> List.count ~f:(Set.mem rolls)) < 4)
  |> Int.to_string
  |> print_endline
