open Base
open Helpers

let possible towel =
  memo_rec
    (module String)
    (fun possible design ->
      String.is_empty design
      || List.init (String.length design) ~f:(fun i ->
             (String.drop_suffix design i, String.suffix design i))
         |> List.filter_map ~f:(fun (pre, suf) ->
                Option.some_if (Set.mem towel pre) suf)
         |> List.exists ~f:possible)

let () =
  let lines = read_lines () in
  let towels =
    List.hd_exn lines |> split_string ", " |> Set.of_list (module String)
  in
  List.drop lines 2 |> List.count ~f:(possible towels) |> Stdio.printf "%d\n"
