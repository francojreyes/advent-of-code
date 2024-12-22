open Base
open Helpers

let mix secret value = Int.bit_xor secret value % 16777216

let next secret =
  let secret = mix secret (Int.shift_left secret 6) in
  let secret = mix secret (Int.shift_right secret 5) in
  mix secret (Int.shift_left secret 11)

let () =
  read_lines ()
  |> List.sum
       (module Int)
       ~f:(fun s -> Int.of_string s |> Fn.apply_n_times ~n:2000 next)
  |> Stdio.printf "%d\n"
