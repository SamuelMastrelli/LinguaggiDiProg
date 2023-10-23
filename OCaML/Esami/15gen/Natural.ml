
module N =
  struct
    type natural = Zero | Succ of natural 
    exception NegativeNumber
    exception DivisionByZero

    let rec ( + ) n1 n2 = 
        match n1, n2 with 
          Zero, n -> n
        | n, Zero -> n
        | Succ(n), m -> Succ(n + m)
    
    let rec compare n1 n2 =
        match n1, n2 with 
          Zero, Succ(n) -> -1 
        | Succ(n), Zero -> 1 
        | Zero, Zero -> 0
        | Succ(n), Succ(m) -> compare n m
    let rec ( - ) n1 n2 =
         match n1, n2 with 
            Zero, Zero -> Zero 
          | Zero, n -> raise NegativeNumber
          | m, Zero -> m 
          | Succ(m), Succ(n) -> m - n    

    let rec ( * ) n1 n2 =
        match n1, n2 with 
          Zero, _ -> Zero
        | _, Zero -> Zero 
        | Succ(Zero), m -> m 
        | m, Succ(Zero) -> m
        | Succ(n), m -> m + (n * m)

    let ( / ) n1 n2 =
      match n2 with 
        Zero -> raise DivisionByZero
      | _  when compare n1 n2 = -1 -> Zero
      | _ -> 
        let rec ( / ) n acc = if compare n n1 > 0 then (acc) 
                         else (n + n2) / (Succ(acc))
        in n2 / Zero 
            
    let eval n =
      let rec eval n acc =
        match n with 
          Zero -> acc 
        | Succ(n) -> eval n (Int.add 1 acc)
      in eval n 0

    let convert i =
        let rec convert i acc =
            match i with 
              0 -> acc 
            | n -> convert (Int.sub n 1) (Succ(acc))
        in convert i Zero

  end;;