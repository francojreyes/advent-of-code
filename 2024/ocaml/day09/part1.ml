open Base
open Helpers

type region = File of int * int | Empty of int

let parse_line line =
  let rec go s file id =
    match s with
    | x :: xs ->
        if file then File (x, id) :: go xs false (id + 1)
        else Empty x :: go xs true id
    | [] -> []
  in
  go (List.filter_map ~f:Char.get_digit (String.to_list line)) true 0

let rec total_files = function
  | File (size, _) :: rs -> size + total_files rs
  | Empty _ :: rs -> total_files rs
  | [] -> 0

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

let compact disk =
  let total_sz = total_files disk in
  let files_rev =
    List.rev disk
    |> List.filter_map ~f:(function
         | Empty _ -> None
         | File (sz, id) -> Some (sz, id))
  in

  let rec go sz files disk =
    if sz = total_sz then []
    else
      match disk with
      | File (n, id) :: rs ->
          if sz + n > total_sz then [ File (total_sz - sz, id) ]
          else File (n, id) :: go (sz + n) files rs
      | Empty n :: rs -> (
          match files with
          | (back_n, back_id) :: fs ->
              let moved = min n back_n in
              let files' =
                if moved = back_n then fs else (back_n - moved, back_id) :: fs
              in
              let rs' = if moved = n then rs else Empty (n - moved) :: rs in
              File (moved, back_id) :: go (sz + moved) files' rs'
          | [] -> rs)
      | [] -> []
  in
  go 0 files_rev disk

let () =
  read_lines ()
  |> List.concat_map ~f:parse_line
  |> compact |> checksum |> Stdio.printf "%d\n"
