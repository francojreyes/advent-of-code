open! Core

let parse_line line =
  String.split line ~on:' ' |> List.filter ~f:(fun s -> not (String.is_empty s))

let solve = function
  | "*" :: nums -> List.map nums ~f:Int.of_string |> List.fold ~init:1 ~f:( * )
  | "+" :: nums -> List.sum (module Int) nums ~f:Int.of_string
  | _ -> 0

let () =
  In_channel.input_lines In_channel.stdin
  |> List.rev
  |> List.map ~f:parse_line
  |> List.transpose_exn
  |> List.sum (module Int) ~f:solve
  |> Int.to_string
  |> print_endline
