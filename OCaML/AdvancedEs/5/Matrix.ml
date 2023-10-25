module Matrix =
  struct
    type matrix = int list list 
    exception NotAMatrix
    
    let is_matrix (l : int list list) =
       if l == [] then false 
       else
       let rec im lenght m =
          match m with 
            [] -> true 
          | h::tl -> if (List.length h) = lenght then 
                          im lenght tl 
                      else false  
       in im (List.length (List.hd l)) (List.tl l)          

    let dims (m:matrix) =
        match is_matrix m with 
            false -> raise NotAMatrix
          | _ ->  (List.length m, List.length (List.hd m))

    
    
          
          
    let eq (m1:matrix) (m2:matrix) = (m1 = m2)
    
    let rec contains l x =
        match l with 
          [] -> false
        | h::tl -> if h=x then true 
                   else contains tl x

    let copy m = 
      match is_matrix m with
         false -> raise NotAMatrix
      |  true -> 
        let rec copy acc = function 
            [] -> acc 
          | h::tl -> copy (h :: acc) tl
        in copy [] m
        
    let add m1 m2 =
        match is_matrix m1, is_matrix m2 with
            false, _ -> raise NotAMatrix
          | _, false -> raise NotAMatrix
          | _, _ -> List.map2 (fun x y -> List.map2 (+) x y) m1 m2

    let smult s m =
      match is_matrix m with
        false -> raise NotAMatrix
      | _ -> List.map (fun x -> List.map (fun y -> s * y) x) m

    let transpose m = 
        match is_matrix m with 
            false -> raise NotAMatrix
          | _ -> let rec tr m acc =
                    match m with 
                      [] -> acc
                    | _ when contains m [] -> acc 
                    | _ -> tr (List.map (List.tl) m) ((List.map (List.hd) m) :: acc)
                 in tr m []

    let pvect v1 v2 =
        let rec pv i1 acc =
            match i1 with 
              _ when i1 = List.length v1 -> acc 
            | _ ->pv (i1 + 1) ((List.nth v1 i1) * (List.nth v2 i1) + acc) 
        in pv 0 0

    let mmult m1 m2 =
      let rec mult i acc =
          match i with 
              _ when i = (List.length m1) -> List.rev acc 
            | _ -> mult (i+1) (List.rev (List.map (pvect (List.nth m1 i)) (transpose m2)):: acc)
      in mult 0 []

    let colSums m =
        match is_matrix m with 
           false -> raise NotAMatrix
         | _ -> let rec clSums acc = function 
                     0 -> List.rev acc 
                   | i -> clSums ((List.fold_left ( + ) 0 (List.map (fun x -> List.nth x i) m))::acc) (i-1)
                in clSums [] ((snd (dims m)) - 1)
    let norm m= 
        List.hd (List.rev (List.sort (-) (colSums m)))

    
  end;;