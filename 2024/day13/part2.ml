open Base
open Helpers

let err = 10000000000000

type eqn = { a : int; b : int; c : int }

let mul { a; b; c } n = { a = a * n; b = b * n; c = c * n }

let parse_block block =
  match find_all_matches "\\d+" block |> List.map ~f:Int.of_string with
  | [ a1; a2; b1; b2; c1; c2 ] ->
      Some ({ a = a1; b = b1; c = err + c1 }, { a = a2; b = b2; c = err + c2 })
  | _ -> None

let parse_input lines =
  List.filter ~f:(Fn.non String.is_empty) lines
  |> List.group ~break:(fun line _ ->
         String.is_substring ~substring:"Prize" line)
  |> List.filter_map ~f:(Fn.compose parse_block String.concat)

let ( // ) x y = if y <> 0 && x % abs y = 0 then Some (x / y) else None

let solve (e1, e2) =
  let e1' = mul e1 e2.a in
  let e2' = mul e2 e1.a in
  let open Option.Let_syntax in
  let%bind b = (e2'.c - e1'.c) // (e2'.b - e1'.b) in
  let%bind a = (e1.c - (e1.b * b)) // e1.a in
  return (a, b)

let () =
  read_lines () |> parse_input |> List.filter_map ~f:solve
  |> List.sum (module Int) ~f:(fun (a, b) -> (3 * a) + b)
  |> Stdio.printf "%d\n"
