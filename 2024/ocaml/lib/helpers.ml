open Stdio

let read_lines () = In_channel.input_lines In_channel.stdin
let split_string delimiter = Re.split (Re.Pcre.regexp delimiter)
