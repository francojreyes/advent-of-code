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

type dir = Up | Right | Down | Left [@@deriving equal, compare, sexp]

let dirs = [ Up; Left; Down; Right ]

let cell_in_dir dir { x; y } =
  match dir with
  | Up -> { x = x - 1; y }
  | Right -> { x; y = y + 1 }
  | Down -> { x = x + 1; y }
  | Left -> { x; y = y - 1 }

let next_dir = function
  | Up -> Right
  | Right -> Down
  | Down -> Left
  | Left -> Up

let prev_dir = function
  | Up -> Left
  | Left -> Down
  | Down -> Right
  | Right -> Up

module Queue : sig
  type 'a t

  val empty : 'a t
  val push : 'a t -> 'a -> 'a t
  val pop : 'a t -> ('a * 'a t) option
  val singleton : 'a -> 'a t
end = struct
  type 'a t = { s1 : 'a list; s2 : 'a list }

  let empty = { s1 = []; s2 = [] }
  let push { s1; s2 } a = { s1 = a :: s1; s2 }

  let pop q =
    let { s1; s2 } =
      if List.is_empty q.s2 then { s1 = []; s2 = List.rev q.s1 } else q
    in
    match s2 with [] -> None | a :: s2 -> Some (a, { s1; s2 })

  let singleton a = push empty a
end
