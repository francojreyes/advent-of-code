open Base
open Helpers

type expr = Do | Dont | Mul of int

let eval_mul mul =
  find_all_matches "\\d+" mul
  |> List.map ~f:Int.of_string |> List.fold ~init:0 ~f:( + )

let parse_expr e =
  match e with "do()" -> Do | "don't()" -> Dont | mul -> Mul (eval_mul mul)

let parse_line line =
  find_all_matches "mul\\(\\d+,\\d+\\)|do\\(\\)|don't\\(\\)" line
  |> List.map ~f:parse_expr

let eval_exprs =
  let rec go acc enabled lst =
    match lst with
    | [] -> acc
    | x :: xs -> (
        match x with
        | Do -> go acc true xs
        | Dont -> go acc false xs
        | Mul m -> go (if enabled then acc + m else acc) enabled xs)
  in
  go 0 true

let () =
  read_lines ()
  |> List.concat_map ~f:parse_line
  |> eval_exprs |> Stdio.printf "%d\n"
