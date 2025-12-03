open! Core

module IntPair = struct 
  module T = struct
    type t = int * int [@@deriving compare, sexp]
  end

  include T
  include Comparable.Make_plain (T)
end

let n_batteries = 12

let max_jolts bank =
  String.to_list bank
  |> List.map ~f:(fun c -> Char.to_int c - (Char.to_int '0'))
  (* [Map.find memo (i, j)] is the max jolts ending up to idx i of length j *)
  |> List.foldi ~init:IntPair.Map.empty ~f:(fun i memo x ->
      List.init (Int.min (i + 1) n_batteries) ~f:(fun j -> j + 1)
      |> List.fold ~init:memo ~f:(fun memo j -> 
        let data = 
          match Map.find memo (i - 1, j - 1), Map.find memo (i - 1, j) with
          | _ when i = 0 && j = 1 -> x
          | _, Some prev_same_len when j = 1 -> Int.max x prev_same_len
          | Some prev_to_extend, None -> prev_to_extend * 10 + x
          | Some prev_to_extend, Some prev_same_len ->
            Int.max (prev_to_extend * 10 + x) prev_same_len
          | _ -> failwith "unreachable"
        in
        Map.set memo ~key:(i, j) ~data))
  |> Fn.flip Map.find_exn (String.length bank - 1, n_batteries)

let () =
  In_channel.input_lines In_channel.stdin
  |> List.sum (module Int) ~f:max_jolts
  |> Int.to_string
  |> print_endline
