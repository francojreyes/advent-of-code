open Base
open Helpers

let mix secret value = Int.bit_xor secret value % 16777216

let next secret =
  let secret = mix secret (Int.shift_left secret 6) in
  let secret = mix secret (Int.shift_right secret 5) in
  mix secret (Int.shift_left secret 11)

let prices init =
  let rec aux acc curr cnt =
    if cnt < 0 then List.rev acc else aux (curr :: acc) (next curr) (cnt - 1)
  in
  aux [] init 2000 |> List.map ~f:(fun x -> x % 10)

let rec diffs = function x :: (y :: _ as xs) -> (y - x) :: diffs xs | _ -> []

let change_key lst =
  diffs lst
  |> List.map ~f:(( + ) 10)
  |> List.fold ~init:0 ~f:(fun acc x -> (20 * acc) + x)

let sequence_prices prices =
  let rec aux acc = function
    | a :: (b :: c :: d :: e :: _ as lst) ->
        let acc =
          match Map.add acc ~key:(change_key [ a; b; c; d; e ]) ~data:e with
          | `Duplicate -> acc
          | `Ok acc -> acc
        in
        aux acc lst
    | _ -> acc
  in
  aux (Map.empty (module Int)) prices

let () =
  read_lines ()
  |> List.map ~f:(fun s -> Int.of_string s |> prices |> sequence_prices)
  |> List.reduce_exn ~f:(Map.merge_skewed ~combine:(fun ~key:_ x y -> x + y))
  |> Map.data
  |> List.max_elt ~compare:Int.compare
  |> Option.value ~default:0 |> Stdio.printf "%d\n"
