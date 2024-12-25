open Base
open Helpers

let rec count_hash cnts s =
  match (cnts, s) with
  | x :: xs, y :: ys ->
      let x' = if Char.equal y '#' then x + 1 else x in
      x' :: count_hash xs ys
  | _ -> []

let parse_block lines =
  let open Option.Let_syntax in
  let%bind is_key = List.hd lines >>| String.equal "....." in
  let%bind pins =
    List.tl lines >>| List.map ~f:String.to_list
    >>| List.fold ~init:[ 0; 0; 0; 0; 0 ] ~f:count_hash
  in
  return (is_key, pins)

let fits (key, lock) =
  List.map2_exn key lock ~f:( + ) |> List.for_all ~f:(fun x -> x <= 6)

let () =
  let keys, locks =
    read_lines ()
    |> List.group ~break:(fun a b -> String.is_empty a || String.is_empty b)
    |> List.filter ~f:(fun g -> List.length g > 1)
    |> List.filter_map ~f:parse_block
    |> List.fold ~init:([], []) ~f:(fun (keys, locks) (is_key, pins) ->
           if is_key then (pins :: keys, locks) else (keys, pins :: locks))
  in
  List.cartesian_product keys locks |> List.count ~f:fits |> Stdio.printf "%d\n"
