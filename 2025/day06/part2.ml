open! Core

let solve = function
  | ('*', nums) -> List.fold nums ~init:1 ~f:( * )
  | ('+', nums) -> List.fold nums ~init:0 ~f:( + )
  | _ -> 0

let trim_and_join column = 
  List.rev column
  |> List.filter ~f:(Fn.non Char.is_whitespace)
  |> String.of_list

(** Like [String.split] for lists, but doesn't leave empty lists *)
let list_split list ~on ~equal =
  List.group list ~break:(fun a b -> (equal a on)  || (equal b on))
  |> List.filter ~f:(Fn.non (List.for_all ~f:(equal on)))

let () =
  let reversed_input_lines =  
    In_channel.input_lines In_channel.stdin
    |> List.map ~f:String.to_list
    |> List.rev
  in
  let ops = 
    List.hd_exn reversed_input_lines
    |> List.filter ~f:(Fn.non Char.is_whitespace)
  in
  let nums = 
    List.tl_exn reversed_input_lines
    |> List.transpose_exn
    |> List.map ~f:trim_and_join
    |> list_split ~on:"" ~equal:String.equal
    |> List.map ~f:(List.map ~f:Int.of_string)
  in
  List.zip_exn ops nums
  |> List.sum (module Int) ~f:solve
  |> Int.to_string
  |> print_endline
