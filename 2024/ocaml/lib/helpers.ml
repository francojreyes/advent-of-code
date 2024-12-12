open Base
open Stdio

let read_lines () = In_channel.input_lines In_channel.stdin
let split_string delimiter = Re.split (Re.Pcre.regexp delimiter)

let find_all_matches regexp str =
  Re.all (Re.Pcre.regexp regexp) str |> List.map ~f:(fun g -> Re.Group.get g 0)

type coord = { x : int; y : int } [@@deriving equal, compare, sexp]

module Coord = struct
  module T = struct
    type t = coord

    let compare = compare_coord
    let sexp_of_t = sexp_of_coord
  end

  let equal = equal_coord

  include T
  include Comparator.Make (T)
end

type dir = Up | Right | Down | Left [@@deriving compare, sexp]
let dirs = [ Up; Left; Down; Right ]

let cell_in_dir dir { x; y } =
  match dir with
  | Up -> { x = x - 1; y }
  | Right -> { x; y = y + 1 }
  | Down -> { x = x + 1; y }
  | Left -> { x; y = y - 1 }