open! Core

let parse_line line =
  if String.is_empty line then `Snd ()
  else match String.lsplit2 line ~on:'-' with
  | Some range -> `Fst (Tuple2.map range ~f:Int.of_string)
  | None -> `Trd (Int.of_string line)

let () =
  let fresh, _, avail =
    In_channel.input_lines In_channel.stdin
    |> List.partition3_map ~f:parse_line
  in
  List.count avail ~f:(fun id ->
    List.exists fresh ~f:(fun (low,  high) -> Int.between id ~low ~high))
  |> Int.to_string
  |> print_endline
