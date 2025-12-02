open! Core

let parse_range range_str =
  let lo, hi =
    String.lsplit2_exn ~on:'-' range_str |> Tuple2.map ~f:Int.of_string
  in
  Sequence.range ~start:`inclusive ~stop:`inclusive lo hi

let is_invalid id =
  let n_digits = Int.to_string id |> String.length in
  match n_digits % 2 = 0 with
  | false -> false
  | true ->
      let power = Int.(10 ** (n_digits / 2)) in
      id % power = id / power

let () =
  In_channel.input_line_exn In_channel.stdin
  |> String.split ~on:','
  |> Sequence.of_list
  |> Sequence.concat_map ~f:parse_range
  |> Sequence.filter ~f:is_invalid
  |> Sequence.sum (module Int) ~f:Fn.id
  |> Int.to_string
  |> print_endline
