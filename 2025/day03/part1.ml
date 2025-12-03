open! Core

let max_jolts bank =
  String.to_list bank
  |> List.map ~f:(fun c -> Char.to_int c - (Char.to_int '0'))
  |> List.fold ~init:(0, 0) ~f:(fun (max_jolts, max_seen) x ->
    let max_jolts = Int.max max_jolts (10 * max_seen + x) in
    let max_seen = Int.max max_seen x in
    max_jolts, max_seen)
  |> fst

let () =
  In_channel.input_lines In_channel.stdin
  |> List.sum (module Int) ~f:max_jolts
  |> Int.to_string
  |> print_endline
