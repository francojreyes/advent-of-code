open! Core

let parse_line line =
  match String.to_list line with
  | 'R' :: clicks -> Int.of_string (String.of_list clicks)
  | 'L' :: clicks -> Int.of_string (String.of_list clicks) |> Int.neg
  | _ -> 0

let () =
  In_channel.input_lines In_channel.stdin
  |> List.map ~f:parse_line
  |> List.fold ~init:(0, 50) ~f:(fun (res, pos) x ->
    let pos = (pos + x) % 100 in
    (if pos = 0 then res + 1 else res), pos)
  |> fst
  |> Int.to_string
  |> print_endline