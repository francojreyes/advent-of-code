open! Core


type machine =
  { target: int 
  ; switches : int list
  ; joltages : int list
  }

let bitset bits = 
  List.fold bits ~init:0 ~f:(fun acc bit -> acc lor (1 lsl bit))

let parse_line line = 
  match String.split ~on:' ' line with
  | [] -> None
  | target :: rest ->
    let target = 
      String.slice target 1 (String.length target - 1)
      |> String.to_list
      |> List.filter_mapi ~f:(fun i c -> Option.some_if (Char.equal '#' c) i)
      |> bitset
    in
    match List.rev rest with
    | [] -> None
    | joltages :: switches ->
      let joltages =
        String.slice joltages 1 (String.length joltages - 1)
        |> String.split ~on:','
        |> List.map ~f:Int.of_string
      in
      let switches = 
        List.map switches ~f:(fun switch ->
          String.slice switch 1 (String.length switch - 1)
          |> String.split ~on:','
          |> List.map ~f:Int.of_string
          |> bitset
        )
      in
      Some { target; switches; joltages }

let rec powerset = function
| [] -> [[]]
| x :: xs ->
  let ss = powerset xs in
  List.map ss ~f:(fun s -> x :: s) @ ss

let solve { target; switches; joltages } =
  ignore joltages;
  powerset switches
  |> List.sort ~compare:(fun a b -> Int.compare (List.length a) (List.length b))
  |> List.find_exn ~f:(fun switches ->
    List.fold switches ~init:0 ~f:( lxor ) |> Int.equal target)
  |> List.length

let () =
  In_channel.input_lines In_channel.stdin
  |> List.filter_map ~f:parse_line
  |> List.sum (module Int) ~f:solve
  |> Int.to_string
  |> print_endline
