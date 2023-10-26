let max2el l =
  match l with 
    [] -> raise (Invalid_argument "La lista non ha gli elementi necessari")
  | [h] -> raise (Invalid_argument "La lista non ha gli elementi necessari")
  | _ -> let sorted = (List.rev (List.sort ( - ) l)) in 
         let max1 = List.hd sorted and 
             max2 = List.hd (List.tl sorted) in 
             (max1, max2) ;;