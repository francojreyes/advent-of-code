open Base
open Helpers

let err = 0

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


(*
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

(1)  94a + 22b = 8400
(2)  34a + 67b = 5400

(1) * 17 =>
(1A) 1598a + 374b = 142800

(2) * 47 =>
(2A) 1598a + 3149b = 253800

(1) - (2) =>
-2775b = -111000
b = 40

Sub b into (1)
94a + 880 = 8400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

(1)  26a + 67b = 12748
(2)  66a + 21b = 12176

(1A) 1716a + 4422b = 841368
(2A) 1716a + 546b = 316576

3876b = 316576

*)
