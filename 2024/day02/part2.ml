open Base
open Helpers

let parse_line s = List.map ~f:Int.of_string (split_string "\\s+" s)

let rec ordered ~cmp lst =
  match lst with
  | x :: y :: rest -> cmp x y && ordered ~cmp (y :: rest)
  | _ -> true

let incr = ordered ~cmp:( < )
let decr = ordered ~cmp:( > )

let rec differs lst =
  match lst with
  | x :: y :: rest -> abs (x - y) <= 3 && differs (y :: rest)
  | _ -> true

let rec drop_each lst =
  match lst with
  | x :: xs -> xs :: List.map ~f:(List.cons x) (drop_each xs)
  | [] -> []

let () =
  read_lines () |> List.map ~f:parse_line
  |> List.filter ~f:(fun r ->
         List.exists
           ~f:(fun r -> (incr r || decr r) && differs r)
           (r :: drop_each r))
  |> List.length |> Stdio.printf "%d\n"
