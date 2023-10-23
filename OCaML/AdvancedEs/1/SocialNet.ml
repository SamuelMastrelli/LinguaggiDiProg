module SocialNet =
  struct
    type sn = SN of (node list * (node * node) list) and node = {name: string}

    exception SCempty 
    exception NodeNotInSC 

    let newNode s = {name = s}

    let empty () = SN ([], [])
    let is_empty = function 
        SN (nodes, _) -> nodes = []

    let rec is_in_list n1 = function
        [] -> false 
      | n::t -> if n = n1 then true else is_in_list n1 t 

    let rec found name = function 
        SN ([], _) -> false 
      | SN (nodes, arcs) -> is_in_list name nodes

    let add_in_list el = function
        l when is_in_list el l -> l
      | l -> List.rev (el :: (List.rev l))
    let add_node n = function
        SN (nodes, arcs) -> SN ((add_in_list n nodes), arcs)

    let add_link n1 n2 = function
          SN (nodes, arcs)  -> SN ( add_in_list n1 (add_in_list n2 nodes), add_in_list (n1, n2) arcs)

    let followed n = function
        SN (nodes, arcs) 
          when is_in_list n nodes -> List.map snd (List.filter (fun x -> (fst x) = n) arcs)
      | _ -> raise NodeNotInSC
    let followers n = function 
        SN (nodes, arcs)
          when is_in_list n nodes -> List.map fst (List.filter (fun x -> (snd x) = n) arcs)
      | _ -> raise NodeNotInSC
                              
  end;;
