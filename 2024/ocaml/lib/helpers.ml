open Base
open Stdio

let read_lines () = In_channel.input_lines In_channel.stdin
let split_string delimiter = Re.split (Re.Pcre.regexp delimiter)

let find_all_matches regexp str =
  Re.all (Re.Pcre.regexp regexp) str |> List.map ~f:(fun g -> Re.Group.get g 0)
