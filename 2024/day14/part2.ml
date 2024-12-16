open Base
open Helpers

let nx = 101
let ny = 103
let secs = 8000

let parse_line line =
  match find_all_matches "-?\\d+" line |> List.map ~f:Int.of_string with
  | [ px; py; vx; vy ] -> Some ({ x = px; y = py }, { x = vx; y = vy })
  | _ -> None

let shift { x; y } { x = dx; y = dy } =
  ({ x = (x + dx) % nx; y = (y + dy) % ny }, { x = dx; y = dy })

let rec print { x; y } robots =
  if x >= nx then (
    Stdio.printf "\n";
    if y >= ny then () else print { x = 0; y = y + 1 } robots)
  else
    match robots with
    | { x = rx; y = ry } :: rs when x = rx && y = ry ->
        Stdio.printf "O";
        print { x = x + 1; y } rs
    | _ ->
        Stdio.printf " ";
        print { x = x + 1; y } robots

let simulate robots =
  let robots' = List.map ~f:(fun (p, v) -> shift p v) robots in
  let sorted =
    List.map ~f:fst robots'
    |> List.sort ~compare:(fun p1 p2 ->
           let cmp = Int.compare p1.y p2.y in
           if cmp = 0 then Int.compare p1.x p2.x else cmp)
    |> List.remove_consecutive_duplicates ~equal:Coord.equal
  in
  print { x = 0; y = 0 } sorted;
  Stdio.printf "------------------------------------------------\n";
  robots'

let () =
  read_lines ()
  |> List.filter_map ~f:parse_line
  |> Fn.apply_n_times ~n:secs simulate
  |> Fn.const ()

(*
X=11,Y=7
p=2,4 v=2,-3


*)
