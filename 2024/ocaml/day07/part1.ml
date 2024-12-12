open Base
open Helpers

let parse_line line =
  match split_string ":? " line with
  | goal :: nums -> Some (Int.of_string goal, List.map ~f:Int.of_string nums)
  | [] -> None

let solvable goal = function
  | [] -> false
  | x :: xs ->
      let rec go acc = function
        | x :: xs -> go (acc + x) xs || go (acc * x) xs
        | [] -> acc = goal
      in
      go x xs

let () =
  read_lines ()
  |> List.filter_map ~f:parse_line
  |> List.filter_map ~f:(fun (goal, nums) ->
         Option.some_if (solvable goal nums) goal)
  |> List.fold ~init:0 ~f:( + ) |> Stdio.printf "%d\n"
