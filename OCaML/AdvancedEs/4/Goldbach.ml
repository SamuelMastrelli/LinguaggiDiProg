


let primes n =
    let lm = List.init (n-2) (fun x -> x + 2) in 
    let rec primes l i =
        match i with 
           _ when i = (List.length l) - 1 -> l 
         | _ -> 
          primes (List.filter (fun x -> (x = (List.nth l i)) || x mod (List.nth l i) <> 0) l) (i + 1)
          
    in primes lm 0;;




let goldbach n =
    match n with
      _ when n mod 2 <> 0 || n <= 2 -> raise (Invalid_argument "Non pari maggiore di due")
    | _ ->  let pri = primes n in
            let rec g l acc =
              match l with 
                  [] -> acc
                | op1::tl -> 
                       let  op2 = n - op1 in 
                        if  (List.exists (fun x -> x = op2) l) then g tl ((op1, op2)::acc)
                        else g tl acc
           in g pri [];;


let goldbach_list n m =
    match n, m with 
      _, _ when n >= m -> []
    | _, _ -> let l = List.init (m-n) (fun x -> x + n) in 
              let rec pp acc = function 
                  [] -> List.rev acc 
                | h::tl -> if h mod 2 <> 0 then pp acc tl
                           else pp ((goldbach h):: acc) tl 
              in pp [] l;;