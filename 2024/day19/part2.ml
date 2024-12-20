open Base
open Helpers

let rec possible ps memo s =
  match Map.find memo s with
  | Some res -> (memo, res)
  | None ->
      if String.is_empty s then (memo, 1)
      else
        let memo, res =
          (s, "")
          :: List.init (String.length s) ~f:(fun i ->
                 (String.prefix s i, String.drop_prefix s i))
          |> List.filter ~f:(fun (pre, _) -> Set.mem ps pre)
          |> List.map ~f:snd
          |> List.fold ~init:(memo, 0) ~f:(reduce ps)
        in
        (Map.set memo ~key:s ~data:res, res)

and reduce ps (memo, acc) s =
  let memo', res = possible ps memo s in
  (memo', acc + res)

let () =
  let lines = read_lines () in
  let patterns =
    List.hd_exn lines |> split_string ", " |> Set.of_list (module String)
  in
  List.drop lines 2
  |> List.fold ~init:(Map.empty (module String), 0) ~f:(reduce patterns)
  |> snd |> Stdio.printf "%d\n"
