open Stdio

let rec read_lines () =
  let line = In_channel.input_line In_channel.stdin in
  match line with Some line -> line :: read_lines () | None -> []

let split_string delimiter = Re.split (Re.Pcre.regexp delimiter)
