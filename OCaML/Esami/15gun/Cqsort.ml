let cqsort ( >: ) l =
    let rec cqsort l k =
      match l with 
        [] | [_] -> k l 
      | h::tl -> cqsort 
                  (List.filter (fun x -> (h >: x)) tl)
                  (fun ll -> k (cqsort 
                                 (List.filter (fun x -> x >: h) tl)
                                 (fun gl -> ll @ (h::gl))))
      in cqsort l (fun x -> x);;