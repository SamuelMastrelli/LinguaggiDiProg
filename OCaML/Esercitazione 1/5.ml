

let toList s =
   let rec tl acc i =
      match i with 
        _ when (String.length s) = i-> List.rev acc  
      | _ -> if (s.[i] >= ' ' && s.[i] <= '/') || (s.[i] >= ':' && s.[i] <= '@') 
             then tl acc (i+1)
             else tl (s.[i]::acc) (i+1)
    in tl [] 0;;


let is_palindrome s =
    let ls = toList (String.lowercase_ascii s) in 
    ls = List.rev ls;;
                                                                                

let (-:) s1 s2 =
    let rec minus acc i1 =
      match i1 with 
         _ when (String.length s1) = i1 -> String.concat "" (List.rev acc)
       | _ -> if String.contains s2 s1.[i1] then minus acc (i1+1) else minus (String.make 1 s1.[i1]::acc) (i1+1)
    in minus [] 0;;

let count s ch =
    let rec c acc i =
      match i with
          _ when (i = String.length s) -> acc 
        | _ -> if (s.[i] = ch) then c (acc+1) (i+1) else c acc (i+1)
    in c 0 0;;

let ana s1 s2 =
    let rec ana i =
      match i with 
          _ when (String.length s1 = i) -> if i = (String.length s2) then true else false 
        | _ -> if (count s1 s1.[i] = count s2 s1.[i]) then ana (i+1) else false
    in ana 0;;


let rec anagram s ls =
    match ls with 
        [] -> false 
      | h::tl -> if ana s h then true else anagram s tl ;;