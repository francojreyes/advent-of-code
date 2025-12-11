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

let on_border (x, y) (x', y') (a, b) =
  a = x || a = x' || b = y || b = y'

let strictly_within (x, y) (x', y') (a, b) =
  not (on_border (x, y) (x', y') (a, b))
  && Int.between a ~low:(Int.min x x') ~high:(Int.max x x')
  && Int.between b ~low:(Int.min y y') ~high:(Int.max y y')

let pairs list =
  let rec loop acc = function
  | [] | [ _ ] -> acc
  | x :: x' :: xs -> loop ((x, x') :: acc) (x' :: xs)
  in
  match list with
  | [] | [ _ ] -> []
  | x :: xs -> (x, List.last_exn xs) :: loop [] xs

let () =
  let points = 
    In_channel.input_lines In_channel.stdin
    |> List.filter_map ~f:parse_line
  in
  let lines = pairs points in
  List.cartesian_product points points
  |> List.filter_map ~f:(fun (a, b) ->
    match
      IntPair.equal a b
      || List.exists points ~f:(strictly_within a b)
      || List.exists lines ~f:(fun (c, d) ->
        (IntPair.(a <> c)
        || IntPair.(a <> d)
        || IntPair.(b <> c)
        || IntPair.(b <> d))
        && on_border a b c
        && on_border a b d)
    with
    | true -> None
    | false -> 
      print_s [%message (a : IntPair.t) (b : IntPair.t) (area a b : int)];
      Some (area a b))
  |> List.max_elt ~compare:Int.compare
  |> Option.value_exn
  |> Int.to_string
  |> print_endline