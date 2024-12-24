open Base
open Helpers

let parse_val s =
  let open Option.Let_syntax in
  let%bind var, value = String.lsplit2 ~on:':' s in
  let%bind tf =
    match value with " 0" -> Some false | " 1" -> Some true | _ -> None
  in
  return (var, tf)

type op = And | Or | Xor [@@deriving equal, sexp]

let get_op = function And -> ( && ) | Or -> ( || ) | Xor -> Bool.( <> )

let parse_op = function
  | "AND" -> Some And
  | "OR" -> Some Or
  | "XOR" -> Some Xor
  | _ -> None

let parse_expr s =
  match String.split ~on:' ' s with
  | [ a; op; b; _; res ] ->
      let a, b = if String.( < ) a b then (a, b) else (b, a) in
      parse_op op |> Option.map ~f:(fun op -> (res, (a, op, b)))
  | _ -> None

let eval_expr vals (res, (a, op, b)) =
  let open Option.Let_syntax in
  let%bind a = Map.find vals a in
  let%bind b = Map.find vals b in
  return (Map.set vals ~key:res ~data:(get_op op a b))

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

let find_wire wires (a, op, b) =
  Stdio.printf "Finding %s %s %s\n" a (sexp_of_op op |> Sexp.to_string) b;
  List.find_exn
    ~f:(fun (_, (a', op', b')) ->
      String.equal a a' && String.equal b b' && equal_op op op')
    wires
  |> fst

let rec validate wires n c =
  if n = 45 then ()
  else
    let x = Printf.sprintf "x%02d" n in
    let y = Printf.sprintf "y%02d" n in
    let z = Printf.sprintf "z%02d" n in
    let c_1 = find_wire wires (x, And, y) in
    let s_1 = find_wire wires (x, Xor, y) in
    let c_2 =
      if String.( < ) s_1 c then (
        assert (String.equal z (find_wire wires (s_1, Xor, c)));
        find_wire wires (s_1, And, c))
      else (
        assert (String.equal z (find_wire wires (c, Xor, s_1)));
        find_wire wires (c, And, s_1))
    in
    let c =
      if String.( < ) c_1 c_2 then find_wire wires (c_1, Or, c_2)
      else find_wire wires (c_2, Or, c_1)
    in
    Stdio.printf "%02d c_1 = %s | s_1 = %s | c_2 = %s | c_out = %s\n" n c_1 s_1
      c_2 c;
    validate wires (n + 1) c

let () =
  let vals, wires =
    read_lines () |> List.split_while ~f:(Fn.non String.is_empty)
  in
  let vals =
    List.filter_map ~f:parse_val vals |> Map.of_alist_exn (module String)
  in
  let wires = List.filter_map ~f:parse_expr wires in
  validate wires 1 (find_wire wires ("x00", And, "y00"));
  eval_exprs vals wires |> get_z |> Stdio.printf "%d\n"

(*
from input, guaranteed to half-add x and y first
full adder

  c_1 = x AND y
  s_1 = x XOR y

  c_2 = s_1 AND c

  z   = s_1 XOR c
  c = c_1 OR c_2

I can find x, y and get c from previous
All the z must be a result of a XOR
EXCEPT the final z45 is an OR

3 z's have an unexpected OR or AND
which accounts for 3 of the mismatches

x09 AND y09 -> z09
  This should go into a c_1
  s_1 = wqr
  (vkd XOR wqr -> gbf) is s_1 XOR c
  gbf is c_1
gbf <-> z09

dpr AND nvv -> z30
  One of these must be an s_1
  Its dpr (y30 XOR x30 -> dpr)
  dpr XOR nvv should be here
nbf <-> z30

rnk OR mkq -> z05
  This is a c_1 or c_2
  I expect an s_1 XOR c
  (y05 AND x05 -> mkq) is a c_1
  (x05 XOR y05 -> wwm) is the s_1
  tsw XOR wwm -> hdt is the s_1 XOR c
hdt <-> z05

100110011010011011110000000011111111011001101
110111100011010111000100111110100100000011001

21117783899853
30540314920985 +
--------------
51658098820838

x = x01, y = y01, c = jfb
find
  s_1 = x01 XOR y01 = jjj
find
  c_1 = x01 AND y01 = cpp
validate
  z = s_1 XOR c
find
  c_2 = s_1 AND c = pss
find
  c = c_1 OR c_2 = rtc

Process found mismatch around z15
jgt <-> mht

gbf,hdt,jgt,mht,nbf,z05,z09,z30

*)
