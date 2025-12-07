open! Core

let parse_splitters line =
  String.to_list line
  |> List.filter_mapi ~f:(fun i c -> Option.some_if (Char.equal c '^') i)
  |> Int.Set.of_list

let split beams splitters = 
  Set.fold beams ~init:(0, Int.Set.empty) ~f:(fun (n_splits, beams) beam ->
    match Set.mem splitters beam with
    | false -> n_splits, Set.add beams beam
    | true -> n_splits + 1, Set.add (Set.add beams (beam + 1)) (beam - 1)
  )

let () =
  let beam = 
    In_channel.input_line_exn In_channel.stdin
    |> (Fn.flip String.index_exn) 'S'
    |> Int.Set.singleton
  in
  In_channel.fold_lines
    In_channel.stdin
    ~init:(0, beam)
    ~f:(fun (n_splits, beams) line ->
      let n_splits', beams = split beams (parse_splitters line) in  
      n_splits + n_splits', beams
    )
  |> fst
  |> Int.to_string
  |> print_endline
