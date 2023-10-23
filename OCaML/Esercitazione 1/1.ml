
let alkaline = [("magnesium", 12); ("beyllium", 4); ("calcium", 20); ("strontium", 38); ("barium", 56); ("radium", 88)];;

let max a b = if (snd a) > (snd b) then a else b;;
let highest ls = List.fold_left (max) (List.hd ls) (List.tl ls);;

let (>:) a b = snd a - snd b;;
let sort ls = List.sort (>:) ls;;

let noble = [("helium", 2); ("neon", 10); ("argon", 18); ("krypton", 36); ("xenon", 54); ("radon", 86)];;

let merge xs ys =
  let sortedXs = sort xs and 
      sortedYs = sort ys in 

      List.merge (>:) sortedXs sortedYs;;