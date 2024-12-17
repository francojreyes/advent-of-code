open Base

let ( ^ ) = Int.bit_xor

let printed a =
  let b = (a % 8) ^ 2 in
  let c = a / (2 ** b) in
  (b ^ c ^ 7) % 8

let prevs n = List.init 8 ~f:(fun i -> (8 * n) + i)

let rec solve digits candidates =
  match digits with
  | [] -> List.hd candidates
  | d :: ds ->
      List.concat_map ~f:prevs candidates
      |> List.filter ~f:(fun x -> x <> 0 && printed x = d)
      |> solve ds

let digits = [ 0; 3; 5; 5; 7; 1; 3; 0; 3; 4; 5; 7; 2; 1; 4; 2 ]

let () =
  solve digits [ 0 ]
  |> Option.sexp_of_t Int.sexp_of_t
  |> Sexp.to_string |> Stdio.print_endline

(*
My input program does this on repeat until A = 0

  2,4,1,2,7,5,4,3,0,3,1,7,5,5

a,0,0

  2,4 -> b = a%8

a,(a%8),0

  1,2 -> b = b^2

a,(a%8)^2,0

  7,5 -> c = a // (2**a)

a,(a%8)^2,c//32

  4,3 -> b = b ^ c

a,((a%8)^2)^(a//32),a // (2**((a%8)^2))

  0,3 -> a = a / 8

a//8,((a%8)^2)^(a // (2**((a%8)^2))),a // (2**((a%8)^2))

  1,7 -> b = b^7 = b^0b111

a//8, (((a%8)^2)^(a // (2**((a%8)^2)))^7, a // (2**((a%8)^2))

  5,5 -> print (b % 8)

b = ((((a % 8) ^ 2) ^ (a // (2 ** ((a % 8) ^ 2)))) ^ 7)

b ^ 7 = (((a % 8) ^ 2) ^ (a // (2 ** ((a % 8) ^ 2))))


print ((((a % 8) ^ 2) ^ (a // (2 ** ((a % 8) ^ 2)))) ^ 7) % 8
a = a // 8
*)
