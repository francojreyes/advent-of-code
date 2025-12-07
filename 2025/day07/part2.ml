open! Core

let parse_splitters line =
  String.to_list line
  |> List.filter_mapi ~f:(fun i c -> Option.some_if (Char.equal c '^') i)
  |> Int.Set.of_list

let split beams splitters = 
  let map_incr n = Map.update ~f:(Option.value_map ~default:n ~f:(( + ) n)) in
  Map.fold beams ~init:Int.Map.empty ~f:(fun ~key:pos ~data:n beams ->
    let pos_after_split = 
      match Set.mem splitters pos with
      | false -> [pos]
      | true -> [pos - 1; pos + 1]
    in
    List.fold pos_after_split ~init:beams ~f:(map_incr n)
  )

let () =
  let start_pos = 
    In_channel.input_line_exn In_channel.stdin
    |> (Fn.flip String.index_exn) 'S'
    |> (Fn.flip Int.Map.singleton) 1
  in
  In_channel.input_lines In_channel.stdin
  |> List.map ~f:parse_splitters
  |> List.fold ~init:start_pos ~f:split
  |> Map.sum (module Int) ~f:Fn.id
  |> Int.to_string
  |> print_endline
