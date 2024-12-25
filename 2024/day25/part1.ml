open Base
open Helpers

let count_hash =
  List.map2_exn ~f:(fun cnt c -> if Char.equal c '#' then cnt + 1 else cnt)

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

let curry f (a, b) = f a b

let () =
  read_lines ()
  |> List.group ~break:(fun a b -> String.is_empty a || String.is_empty b)
  |> List.filter ~f:(fun g -> List.length g > 1)
  |> List.filter_map ~f:parse_block
  |> List.partition_map ~f:(fun (is_key, pins) ->
         if is_key then First pins else Second pins)
  |> curry List.cartesian_product
  |> List.count ~f:fits |> Stdio.printf "%d\n"
