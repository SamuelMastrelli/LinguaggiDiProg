module type MonoidADT =
  sig
    type t 
    val set :  t list 

    val identity : t
    val op : t -> t -> t
  end
module Monoid (M : MonoidADT) = 
struct
  type t = M.t 
  let set = M.set 

  let identity = M.identity

  let op = M.op

  let rec test_id set =
      match set with 
          [] -> true 
        | h::tl -> if (op identity h = h) then 
                        test_id tl 
                   else false 
        
  let test_single_assoc a b c =
      (op (op a b) c) = ( op a (op b c))

  let test_assoc set =
    match set with
       [] -> false
     | h::_ -> (List.for_all (fun x -> List.for_all (fun y -> test_single_assoc h x y)  set ) set)
     
  let is_monoid = (test_assoc set) && (test_id set)
end

module IntMonoid = 
struct
  type t = int 
  let set = List.init 10 (fun x ->  x)

  let identity = 0

  let op = ( + )
end;;


module M1 = Monoid(IntMonoid);;

let is = M1.is_monoid;;

let ex = M1.op 4 5;;

