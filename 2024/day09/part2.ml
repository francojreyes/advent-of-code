open Base
open Helpers

type region = File of int * int | Empty of int

let is_file = function File _ -> true | _ -> false

let parse_line line =
  let rec go s file id =
    match s with
    | x :: xs ->
        if file then File (x, id) :: go xs false (id + 1)
        else Empty x :: go xs true id
    | [] -> []
  in
  go (List.filter_map ~f:Char.get_digit (String.to_list line)) true 0

(* let print_file_map lst =
   List.iter
     ~f:(function
       | File (x, id) -> for _ = 1 to x do Stdio.printf "%d" id done
       | Empty x -> for _ = 1 to x do Stdio.printf "." done) lst;
   Stdio.printf "\n" *)

let sum_interval l r = (r - l + 1) * (l + r) / 2

let checksum =
  let rec go acc idx = function
    | File (sz, id) :: rs ->
        go (acc + (id * sum_interval idx (idx + sz - 1))) (idx + sz) rs
    | Empty sz :: rs -> go acc (idx + sz) rs
    | [] -> acc
  in
  go 0 0

let rec extract_file id = function
  | [] -> None
  | x :: xs -> (
      match x with
      | File (sz, id') when id' = id -> Some ((sz, id'), Empty sz :: xs)
      | _ ->
          Option.map ~f:(fun (y, rest) -> (y, x :: rest)) (extract_file id xs))

let rec insert_file (sz, id) disk =
  match disk with
  | Empty sz' :: rs when sz' >= sz ->
      File (sz, id) :: (if sz' = sz then rs else Empty (sz' - sz) :: rs)
  | r :: rs -> r :: insert_file (sz, id) rs
  | [] -> [ File (sz, id) ]

let move_file (disk, id) =
  match extract_file id disk with
  | Some (file, disk') -> (insert_file file disk', id - 1)
  | None -> (disk, id - 1)

let compact disk =
  let n_files = List.count ~f:is_file disk in
  Fn.apply_n_times ~n:n_files move_file (disk, n_files) |> fst

let () =
  read_lines ()
  |> List.concat_map ~f:parse_line
  |> compact |> checksum |> Stdio.printf "%d\n"
