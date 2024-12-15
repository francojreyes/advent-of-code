open Base
open Helpers

let nx = 101
let ny = 103
let secs = 100

let parse_line line =
  match find_all_matches "-?\\d+" line |> List.map ~f:Int.of_string with
  | [ px; py; vx; vy ] -> Some ({ x = px; y = py }, { x = vx; y = vy })
  | _ -> None

let shift { x; y } { x = dx; y = dy } =
  { x = (x + (secs * dx)) % nx; y = (y + (secs * dy)) % ny }

let accumulate (tl, tr, bl, br) { x; y } =
  let xmid = nx / 2 in
  let ymid = ny / 2 in
  if x = xmid || y = ymid then (tl, tr, bl, br)
  else
    match (x < xmid, y < ymid) with
    | true, false -> (tl, tr, bl + 1, br)
    | true, true -> (tl + 1, tr, bl, br)
    | false, false -> (tl, tr, bl, br + 1)
    | false, true -> (tl, tr + 1, bl, br)

let () =
  read_lines ()
  |> List.filter_map ~f:parse_line
  |> List.map ~f:(fun (p, v) -> shift p v)
  |> List.fold ~init:(0, 0, 0, 0) ~f:accumulate
  |> fun (tl, tr, bl, br) ->
  Stdio.printf "%d * %d * %d * %d = %d\n" tl tr bl br (tl * tr * bl * br)

(*
X=11,Y=7
p=2,4 v=2,-3


*)
