let somme l =
  let rec somme s accl = function
      [] -> List.rev accl 
    | h::tl -> match h with 
                  0 -> (match s with 
                        0 -> somme 0 accl tl 
                      | _ -> somme 0 (s :: accl) tl)
                | _ -> somme (s+h) accl tl 
in somme 0 [] l ;;