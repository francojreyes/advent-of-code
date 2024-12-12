open Base
open Helpers

type graph = {
  edges : (int, int list, Int.comparator_witness) Map.t;
  indeg : (int, int, Int.comparator_witness) Map.t;
}

let empty = { edges = Map.empty (module Int); indeg = Map.empty (module Int) }

let add_edge { edges; indeg } (u, v) =
  {
    edges =
      Map.update edges u ~f:(Option.value_map ~default:[ v ] ~f:(List.cons v));
    indeg = Map.update indeg v ~f:(Option.value_map ~default:1 ~f:(( + ) 1));
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
  List.filter
    ~f:(fun k -> not (List.mem vs k ~equal:phys_equal))
    (Map.keys g.edges)
  |> List.fold ~init:g ~f:remove_edges_of

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
         if valid_update (subgraph init_graph u) u then middle u else None)
  |> List.fold ~init:0 ~f:( + ) |> Stdio.printf "%d\n"
