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
    let next_pos = pos + x in
    let res = 
      match Int.sign next_pos with
      | Zero -> res + 1
      | Pos -> res + (next_pos / 100)
      | Neg -> res + ((Int.abs next_pos) / 100 + 1) - (Bool.to_int (pos = 0))
    in
    res, next_pos % 100)
  |> fst
  |> Int.to_string
  |> print_endline