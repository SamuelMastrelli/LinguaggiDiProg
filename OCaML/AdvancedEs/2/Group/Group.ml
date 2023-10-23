open GroupADT;;

module Group (G : GroupADT) =
  struct
    type t = G.t
    let set = G.set 
    let identity = G.identity

    let op = G.op

    let rec test_id set =
        match set with 
           [] -> true 
         | h::tl -> if (op identity h = h) then test_id tl 
                    else false 
    let test_sigle_assoc a b c =
        (op (op a b) c) = (op a (op b c))
        
    let test_assoc set =
        match set with 
          [] -> true 
        | h::_ -> List.for_all (fun x -> List.for_all (fun y -> test_sigle_assoc h x y) set) set


    let rec contains el l =
        match l with 
          [] -> false 
        | h::t -> if h=el then true 
                  else contains el t  
    let closure set =
        List.for_all (fun x -> List.for_all (fun y -> contains (op x y) set) set) set
  end
