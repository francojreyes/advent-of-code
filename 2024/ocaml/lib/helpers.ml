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
