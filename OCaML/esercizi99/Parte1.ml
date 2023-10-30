(*1*)
let rec last l =
    match l with 
      | [] -> None 
      | [x] -> Some x 
      | _ ::t -> last t;;

  
(*2*)
let rec last l =
  match l with 
    | [] -> None 
    | [x] -> None 
    | [x; y] -> Some x
    | _::t -> last t;;

(*3*)

let at n l =
    let rec at i = function 
        [] -> None 
      | h::tl -> match i=n with 
                  true -> Some h 
                | _ -> at (i+1) tl 
    in at 0 l;;

let at = List.nth_opt ;;


(*4*)

let length l =
  let rec length acc = function
      [] -> acc 
    | _::tl -> length (acc+1) tl 
in length 0 l;;

(*5*)

let rev l =
    let rec rev acc = function
        [] -> acc 
      | h::tl -> rev (h::acc) tl 
in rev [] l;;

(*6*)

let is_palindrome l =
    (rev l) = l ;;

(*7*)
type 'a node =
    | One of 'a | Many of 'a node list;;

let flatten an =
    let rec flatten acc = function 
        One a :: t -> flatten (a::acc) t 
      | [] -> acc
      | Many n::ns -> flatten (flatten (acc) n ) ns
in flatten [] an;;

(*8*)

let compress l =
  match l with 
    [] -> []
  | _ ->  
    let rec com n acc = function
      [] -> List.rev acc
    | h::t -> match h = n with 
                true -> com h acc t
              | _ -> com h (h::acc) t
    in com (List.hd l) [(List.hd l)] (List.tl l);;

(*9*)

let pack l =
  let rec pack el acc acclist = function
      [] -> List.rev (acc::acclist)
    | h::tl -> match h=el with 
                  true -> pack h (h::acc) acclist tl 
                | _ -> pack h [h] (acc::acclist) tl 
    in
    match l with 
      [] -> []
    | h::tl -> pack h [h] [] tl;;

(*10*)
let encode l =
  let rec encode el (el, n) acclist = function
      [] -> List.rev ((el, n)::acclist)
    | h::tl -> match h=el with 
                  true -> encode h (h, n+1) acclist tl 
                | _ -> encode h (h, 1) ((el, n)::acclist) tl 
    in
    match l with 
      [] -> []
    | h::tl -> encode h (h, 1) [] tl;;


(*11*)

type 'a rle =
    | One of 'a 
    | Many of int * 'a ;;

let encode l =
  let rec encode acc acclist = function 
      [] -> List.rev (acc::acclist)
    | h::tl -> match acc with 
                  One b when b = h -> encode (Many (2, h)) acclist tl 
                | One b -> encode (One h) (acc::acclist) tl 
                | Many (n, b) when b=h -> encode (Many ((n+1), h)) acclist tl 
                | Many (n, b) -> encode (One h) (acc::acclist) tl
in match l with 
    [] -> []
  | h::tl -> encode (One h) [] tl ;;


(*12*)

let decode l =
    let rec decode acc = function
        [] -> List.rev acc 
      | (One el)::tl -> decode (el::acc) tl 
      | (Many (2, el)::tl) -> decode (el::acc) ((One el)::tl)
      | (Many (n, el)::tl) -> decode (el::acc) ((Many ((n-1), el))::tl)
in decode [] l;;

(*14*)

let duplicate l =
    let rec dup acc = function
        [] -> List.rev acc
      | h::tl -> dup (h :: (h::acc)) tl 
in dup [] l;;

(*16*)

let drop l pos =
  let rec drop i = function
    [] -> []
  | h::t when pos = i -> drop 1 t 
  | h::t -> h :: drop (i+1) t
in drop 1 l;;

(*17*)

let split l lunghezza =
  let rec split n (acc1, acc2) =function
     [] -> (List.rev acc1, acc2)
   | h::t when n < lunghezza -> split (n+1) (h::acc1, acc2) t
   | h::t -> split n (h::acc1, t) []
in split 0 ([], []) l;;

(*18*)

let slice lst low high =
    let rec slice l acc =
      match l with 
        _ when l > high -> List.rev acc 
      | _ -> slice (l+1) (List.nth lst l :: acc)
    in
      match low, high with 
        _, _ when low >= high -> raise (Invalid_argument "Invalid bounds")
      | _, _ when (low >= List.length lst) -> raise (Invalid_argument "Invalid boounds")
      | _, _ -> slice low [];;

(*19*)

let rotate l n =
  let rec rotate acc lst = function
    0 when n >= 0 -> lst @ (List.rev acc)
  | 0 -> acc @ List.rev lst
  | n -> rotate ((List.hd lst)::acc) (List.tl lst) (n-1)
in 
  let new_n ls = function 
    i when i < 0 -> ((- i), (List.rev ls))
  | i -> (i, ls)
in let (nn, ll) = new_n l n in
rotate [] ll nn;;
    