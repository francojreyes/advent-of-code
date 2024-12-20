open Base
open Helpers

let rec possible ps memo s =
  match Map.find memo s with
  | Some res -> (memo, res)
  | None ->
      if String.is_empty s then (memo, true)
      else
        let memo, res =
          List.init (String.length s) ~f:(fun i ->
              (String.drop_suffix s i, String.suffix s i))
          |> List.filter ~f:(fun (pre, _) -> Set.mem ps pre)
          |> List.fold_until ~init:memo
               ~f:(fun memo (_, suf) ->
                 let memo', res = possible ps memo suf in
                 if res then Stop (memo', true) else Continue memo')
               ~finish:(fun memo -> (memo, false))
        in
        (Map.set memo ~key:s ~data:res, res)

let () =
  let lines = read_lines () in
  let patterns =
    List.hd_exn lines |> split_string ", " |> Set.of_list (module String)
  in
  List.drop lines 2
  |> List.fold
       ~init:(Map.empty (module String), 0)
       ~f:(fun (memo, cnt) s ->
         let memo', res = possible patterns memo s in
         (memo', if res then cnt + 1 else cnt))
  |> snd |> Stdio.printf "%d\n"
