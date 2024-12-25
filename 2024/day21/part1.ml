open Base
open Helpers

let numpad =
  ( (function
    | '7' -> { x = 0; y = 0 }
    | '8' -> { x = 0; y = 1 }
    | '9' -> { x = 0; y = 2 }
    | '4' -> { x = 1; y = 0 }
    | '5' -> { x = 1; y = 1 }
    | '6' -> { x = 1; y = 2 }
    | '1' -> { x = 2; y = 0 }
    | '2' -> { x = 2; y = 1 }
    | '3' -> { x = 2; y = 2 }
    | '0' -> { x = 3; y = 1 }
    | 'A' -> { x = 3; y = 2 }
    | _ -> raise (Failure "invalid char")),
    { x = 3; y = 0 } )

let dpad =
  ( (function
    | '^' -> { x = 0; y = 1 }
    | 'A' -> { x = 0; y = 2 }
    | '<' -> { x = 1; y = 0 }
    | 'v' -> { x = 1; y = 1 }
    | '>' -> { x = 1; y = 2 }
    | _ -> raise (Failure "invalid char")),
    { x = 0; y = 0 } )

let passes_gap gap src dst =
  let mid =
    if src.y < dst.y then { x = dst.x; y = src.y } else { x = src.x; y = dst.y }
  in
  Coord.equal gap mid

(*
to avoid gaps:
 up, left -> up before left
 down, right -> right before down
 up, right -> right before up
 down, left -> down before left

 R -> D -> U -> L

for shortest path:
 left before up
 left before down
 down before right

 L -> U -> D -> R

 reverse because it's reversed later
*)
let moves (pad, gap) src dst =
  let src = pad src in
  let dst = pad dst in
  let dx = dst.x - src.x in
  let dy = dst.y - src.y in
  let res =
    List.init ~f:(Fn.const '<') (abs (min dy 0))
    @ List.init ~f:(Fn.const '^') (abs (min dx 0))
    @ List.init ~f:(Fn.const 'v') (max dx 0)
    @ List.init ~f:(Fn.const '>') (max dy 0)
  in
  if passes_gap gap src dst then res else List.rev res

let move_sequence pad keys =
  let rec go acc prev keys =
    match keys with
    | [] -> acc
    | key :: keys ->
        let acc = 'A' :: (moves pad prev key @ acc) in
        go acc key keys
  in
  go [] 'A' keys |> List.rev

let complexity code =
  let num = Int.of_string (String.prefix code 3) in
  let robot1_seq = move_sequence numpad (String.to_list code) in
  let my_seq = Fn.apply_n_times ~n:2 (move_sequence dpad) robot1_seq in
  Stdio.printf "%d * %d\n" (List.length my_seq) num;
  num * List.length my_seq

let () =
  read_lines () |> List.sum (module Int) ~f:complexity |> Stdio.printf "%d\n"

(*

+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+

    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+

v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA^<A>Av<A>^AA<A>Av<A<A>>^AAAvA^<A>A
<A>A<AAv<AA>>^AvAA^Av<AAA>^A
^A^^<<A>>AvvvA
379A
68 * 379

<<vA^>>AvA^A<<vAA>A^>AA<Av>A^AAvA^A<vA^>AA<A>A<<vA>A^>AAA<Av>A^A
<A>A<<vAA^>AA>AvAA^A<vAAA^>A
^A<<^^A>>AvvvA
379A
64 * 379

2^4 = 16 robot1_seq, avg len 16
16 * 2^16 ~= 1mil robot2_seq, avg len 30
  *)
