open! Core

module Graph = struct 
  type t = { neighbours: string list String.Map.t; indegrees : int String.Map.t }
  let empty = { neighbours = String.Map.empty; indegrees = String.Map.empty }
  let add_edge { neighbours; indegrees } ~from to_ =
    { neighbours = Map.add_multi neighbours ~key:from ~data:to_
    ; indegrees =
        Map.update indegrees to_ ~f:(Option.value_map ~default:1 ~f:(( + ) 1))
        |> Fn.flip Map.update from ~f:(Option.value ~default:0)
    }

  let reverse_topsort { neighbours; indegrees } =
    let rec loop acc indegrees q = 
      match Fqueue.dequeue q with
      | None -> acc
      | Some (node, q) ->
        let q, indegrees =
          Map.find neighbours node
          |> Option.value ~default:[]
          |> List.fold ~init:(q, indegrees) ~f:(fun (q, indegrees) node ->
            let indegree = Map.find_exn indegrees node in
            let indegree = indegree - 1 in
            let q = if indegree = 0 then Fqueue.enqueue q node else q in
            q, Map.set indegrees ~key:node ~data:indegree
          )
        in
        loop (node :: acc) indegrees q
    in
    let q =
      Map.filter indegrees ~f:(( = ) 0) |> Map.keys |> Fqueue.of_list
    in
    loop [] indegrees q
end

let parse_line line = 
  let node, neighbours = String.lsplit2_exn line ~on:':' in
  let neighbours =
    String.split neighbours ~on:' '
    |> List.map ~f:String.strip
    |> List.filter ~f:(Fn.non String.is_empty)
  in
  node, neighbours

let () =
  let graph = 
    In_channel.input_lines In_channel.stdin
    |> List.fold ~init:Graph.empty ~f:(fun graph line ->
      let node, neighbours = parse_line line in
      List.fold neighbours ~init:graph ~f:(Graph.add_edge ~from:node)
    )
  in
  Graph.reverse_topsort graph
  |> List.fold ~init:(String.Map.singleton "out" 1) ~f:(fun paths node ->
    match node with
    | "out" -> paths
    | _ ->
      let data = 
        Map.find graph.neighbours node
        |> Option.value ~default:[]
        |> List.sum (module Int) ~f:(fun neighbour ->
          Map.find paths neighbour |> Option.value ~default:0)
      in
      Map.set paths ~key:node ~data)
  |> Fn.flip Map.find_exn "you"
  |> Int.to_string
  |> print_endline

