let countseq l =
  match l with 
    [] -> []
  | _ -> let rec countseq n accList accn = function 
              [] -> List.rev (accn :: accList) 
            | h::tl ->  
                    match (n=h) with 
                      true -> countseq h (accList) (accn + 1) tl
                    |  _ -> countseq h (accn:: accList) (1) tl
          in countseq (List.hd l) [] 1 (List.tl l);;