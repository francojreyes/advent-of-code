open Base
open Helpers

let digits x = Int.of_float (Float.log10 (Float.of_int x)) + 1

let blink x =
  if x = 0 then [ 1 ]
  else
    let n = digits x in
    if n % 2 = 0 then
      let place = 10 ** (n / 2) in
      [ x / place; x % place ]
    else [ 2024 * x ]

(* Blink on x y times *)
let rec count memo x y =
  if y = 0 then (memo, 1)
  else
    match Map.find memo { x; y } with
    | Some n -> (memo, n)
    | None ->
        let combine (memo, acc) x =
          let memo', n = count memo x (y - 1) in
          (memo', acc + n)
        in
        let memo', n = List.fold ~init:(memo, 0) ~f:combine (blink x) in
        (Map.set memo' ~key:{ x; y } ~data:n, n)

let y = 75

let () =
  Stdio.In_channel.input_line Stdio.stdin
  |> Option.value ~default:"" |> String.split ~on:' '
  |> List.map ~f:Int.of_string
  |> List.fold
       ~init:(Map.empty (module Coord), 0)
       ~f:(fun (memo, acc) x ->
         let memo', n = count memo x y in
         (memo', acc + n))
  |> snd |> Stdio.printf "%d\n"
