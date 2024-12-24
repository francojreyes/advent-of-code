open Base
open Helpers

let parse_val s =
  let open Option.Let_syntax in
  let%bind var, value = String.lsplit2 ~on:':' s in
  let%bind tf =
    match value with " 0" -> Some false | " 1" -> Some true | _ -> None
  in
  return (var, tf)

let parse_op = function
  | "AND" -> Some ( && )
  | "OR" -> Some ( || )
  | "XOR" -> Some Bool.( <> )
  | _ -> None

let parse_expr s =
  match String.split ~on:' ' s with
  | [ a; op; b; _; res ] ->
      parse_op op |> Option.map ~f:(fun op -> (a, op, b, res))
  | _ -> None

let eval_expr vals (a, op, b, res) =
  let open Option.Let_syntax in
  let%bind a = Map.find vals a in
  let%bind b = Map.find vals b in
  return (Map.set vals ~key:res ~data:(op a b))

let rec eval_exprs vals = function
  | [] -> vals
  | exprs ->
      let vals, exprs =
        List.fold ~init:(vals, [])
          ~f:(fun (vals, rem) expr ->
            match eval_expr vals expr with
            | Some vals -> (vals, rem)
            | None -> (vals, expr :: rem))
          exprs
      in
      eval_exprs vals exprs

let get_z vals =
  Map.to_alist ~key_order:`Decreasing vals
  |> List.filter_map ~f:(fun (k, v) ->
         if String.is_prefix k ~prefix:"z" then
           Some (Int.to_string (Bool.to_int v))
         else None)
  |> String.concat |> ( ^ ) "0b" |> Int.of_string

let () =
  let vals, exprs =
    read_lines () |> List.split_while ~f:(Fn.non String.is_empty)
  in
  let vals =
    List.filter_map ~f:parse_val vals |> Map.of_alist_exn (module String)
  in
  exprs
  |> List.filter_map ~f:parse_expr
  |> eval_exprs vals |> get_z |> Stdio.printf "%d\n"
