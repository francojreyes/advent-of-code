open! Core

let parse_range range_str =
  let lo, hi =
    String.lsplit2_exn ~on:'-' range_str |> Tuple2.map ~f:Int.of_string
  in
  Sequence.range ~start:`inclusive ~stop:`inclusive lo hi

let is_invalid id =
  let id = Int.to_string id in
  let chars = String.to_list id in
  Sequence.range ~start:`inclusive ~stop:`inclusive 1 (String.length id / 2)
  |> Sequence.exists ~f:(fun chunk_length ->
    List.chunks_of ~length:chunk_length chars
    |> List.all_equal ~equal:[%equal: char list]
    |> Option.is_some)

let () =
  In_channel.input_line_exn In_channel.stdin
  |> String.split ~on:','
  |> Sequence.of_list
  |> Sequence.concat_map ~f:parse_range
  |> Sequence.filter ~f:is_invalid
  |> Sequence.sum (module Int) ~f:Fn.id
  |> Int.to_string
  |> print_endline
