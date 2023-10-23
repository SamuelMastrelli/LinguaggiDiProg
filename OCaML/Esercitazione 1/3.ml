
type matrix = int list list;;

let zeroes n m = List.init n (fun x -> List.init m (fun x -> 0));;

let identity n = List.init n (fun x -> List.init n (fun y -> if x = y then 1 else 0));;

let init n = List.init n (fun x -> List.init n (fun y -> x*n + y+1));;

let rec transpose = function
    [] -> [] 
  | tl when (List.for_all (fun x -> match x with [] -> true | _ -> false) tl) -> []
  | h::t -> (List.map (List.hd) (h::t)) :: (transpose (List.map (List.tl) (h::t)));;
  

let sumVect l1 l2 =
  let rec s v1 v2 acc =
    match v1, v2 with 
      [], _ | _, []-> List.rev acc 
    | (h1::tl1), (h2::tl2) -> s tl1 tl2 ((h1+h2) :: acc)
  in s l1 l2 [];;

let (+:) m1 m2 =
    let rec sum m1 m2 acc =
        match m1, m2 with 
          [], _ | _, [] -> List.rev acc 
        | (h1::tl1), (h2::tl2) -> sum tl1 tl2 ((sumVect h1 h2) :: acc)
    in sum m1 m2 [];;


let prodVect v1 v2 = 
    let rec p (acc : int) = function 
        [], [] -> acc 
      | [], _ | _, [] -> raise (Invalid_argument "Lunghezza non valida")
      | (h::tl), (h1::tl1) -> p (acc + h*h1) (tl, tl1)
    in p 0 (v2, v1);; 


let ( *: ) m1 m2 =
    	let rec prod acc m1 m2 =
         match m1, m2 with 
            [], [] | _, [] -> transpose (List.rev acc) 
          | [], _  -> raise (Invalid_argument "Dimensione non valida")
          | _, (v2::tl2) -> prod ((List.map (prodVect v2) m1) :: acc) m1 tl2 
      in prod [] m1 (transpose m2);;