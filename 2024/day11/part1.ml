open Base
open Helpers

let digits x = Int.of_float (Float.log10 (Float.of_int x)) + 1

let blink = function
  | 0 -> [ 1 ]
  | x ->
      let n = digits x in
      if n % 2 = 0 then
        let place = 10 ** (n / 2) in
        [ x / place; x % place ]
      else [ 2024 * x ]

let () =
  Stdio.In_channel.input_line Stdio.stdin
  |> Option.value ~default:"" |> split_string "\\s+"
  |> List.map ~f:Int.of_string
  |> Fn.apply_n_times ~n:25 (List.concat_map ~f:blink)
  |> List.length |> Stdio.printf "%d\n"
