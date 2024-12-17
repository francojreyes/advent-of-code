open Base
open Helpers

type state = { a : int; b : int; c : int } [@@deriving sexp]

let parse_input s =
  match find_all_matches "\\d+" s |> List.filter_map ~f:Int.of_string_opt with
  | a :: b :: c :: ops -> ({ a; b; c }, ops)
  | _ -> ({ a = 0; b = 0; c = 0 }, [])

let eval head ({ a; b; c } as state) ops inst op =
  let lit = op in
  let combo =
    match op with 4 -> state.a | 5 -> state.b | 6 -> state.c | _ -> op
  in
  match inst with
  | 0 -> ({ a = a / (2 ** combo); b; c }, ops)
  | 1 -> ({ a; b = Int.bit_xor b lit; c }, ops)
  | 2 -> ({ a; b = combo % 8; c }, ops)
  | 3 -> if a = 0 then (state, ops) else (state, List.drop head lit)
  | 4 -> ({ a; b = Int.bit_xor b c; c }, ops)
  | 5 ->
      Stdio.printf "%d " (combo % 8);
      (state, ops)
  | 6 -> ({ a; b = a / (2 ** combo); c }, ops)
  | 7 -> ({ a; b; c = a / (2 ** combo) }, ops)
  | _ -> (state, ops)

let rec run head state ops =
  match ops with
  | inst :: op :: ops ->
      let state', ops' = eval head state ops inst op in
      Stdio.printf "%s\n" (Sexp.to_string @@ sexp_of_state state');
      run head state' ops'
  | _ -> ()

let () =
  let state, ops = In_channel.input_all In_channel.stdin |> parse_input in
  Stdio.printf "%s\n" (Sexp.to_string @@ sexp_of_state state);
  run ops state ops;
  Stdio.printf "\n"

(*
Register A: 61657405
Register B: 0
Register C: 0

Program: 2,4,1,2,7,5,4,3,0,3,1,7,5,5,3,0


  *)
