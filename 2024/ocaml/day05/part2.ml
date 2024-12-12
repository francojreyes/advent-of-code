open Base
open Helpers

type graph = {
  edges : (int, int list, Int.comparator_witness) Map.t;
  indeg : (int, int, Int.comparator_witness) Map.t;
}

let empty = { edges = Map.empty (module Int); indeg = Map.empty (module Int) }

let add_vertex v { edges; indeg } =
  {
    edges =
      (match Map.add ~key:v ~data:[] edges with
      | `Ok m -> m
      | `Duplicate -> edges);
    indeg =
      (match Map.add ~key:v ~data:0 indeg with
      | `Ok m -> m
      | `Duplicate -> indeg);
  }

let add_edge g (u, v) =
  let { edges; indeg } = add_vertex u g |> add_vertex v in
  {
    edges = Map.change edges u ~f:(Option.map ~f:(List.cons v));
    indeg = Map.change indeg v ~f:(Option.map ~f:(( + ) 1));
  }

let remove_edges_of { edges; indeg } u =
  let edges_of_u = Map.find edges u |> Option.value ~default:[] in
  {
    edges = Map.set edges ~key:u ~data:[];
    indeg =
      List.fold edges_of_u ~init:indeg ~f:(fun m v ->
          Map.change m v ~f:(Option.map ~f:(Fn.flip ( - ) 1)));
  }

let subgraph g vs =
  let keep k = List.mem vs k ~equal:( = ) in
  let removed = List.filter ~f:(Fn.non keep) (Map.keys g.edges) in
  let { edges; indeg } = List.fold ~init:g ~f:remove_edges_of removed in
  {
    edges = Map.filter_keys edges ~f:keep;
    indeg = Map.filter_keys indeg ~f:keep;
  }

let parse_edge line =
  let u, v = String.lsplit2_exn ~on:'|' line in
  (Int.of_string u, Int.of_string v)

let parse_update line =
  String.split ~on:',' line
  |> List.filter ~f:(Fn.non String.is_empty)
  |> List.map ~f:Int.of_string

let rec valid_update g updates =
  match updates with
  | u :: us -> (
      match Map.find g.indeg u with
      | Some 0 | None -> valid_update (remove_edges_of g u) us
      | _ -> false)
  | [] -> true

let middle l =
  let rec go slow fast =
    match (slow, fast) with
    | _ :: ss, _ :: _ :: fs -> go ss fs
    | x :: _, _ -> Some x
    | _ -> None
  in
  go l l

let find_key_with_value_zero map =
  Map.to_alist map |> List.find ~f:(fun (_, v) -> v = 0) |> Option.map ~f:fst

let rec topsort { edges; indeg } =
  match find_key_with_value_zero indeg with
  | Some v ->
      v :: topsort (remove_edges_of { edges; indeg = Map.remove indeg v } v)
  | None -> []

let () =
  let rules, updates =
    read_lines () |> List.split_while ~f:(Fn.non String.is_empty)
  in
  let updates = List.drop_while ~f:String.is_empty updates in
  let init_graph =
    List.fold ~init:empty ~f:(fun g l -> parse_edge l |> add_edge g) rules
  in
  List.map ~f:parse_update updates
  |> List.filter_map ~f:(fun u ->
         let g' = subgraph init_graph u in
         if valid_update g' u then None else middle (topsort g'))
  (* |> List.iter ~f:(fun l -> List.iter ~f:(Stdio.printf "%d ") l; Stdio.printf "\n") *)
  |> List.fold ~init:0 ~f:( + )
  |> Stdio.printf "%d\n"
