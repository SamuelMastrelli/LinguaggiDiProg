open IntervalI;;
open Comparable;;

module Interval (Endpoint : Comparable) : (IntervalI with type endpoint = Endpoint.t) =
  struct
    type endpoint = Endpoint.t 
    type interval = Interval of endpoint * endpoint | Empty

    exception WrongInterval

    let create e1 e2 = 
       let c = Endpoint.compare e2 e1 in 
       match  c with
       | 0 -> Empty
       | _ when c < 0 -> raise WrongInterval
       | _ -> Interval (e1, e2)
 
    let is_empty = function
        Empty -> true
      | _ -> false

    let contains i e =
        match i with 
          Empty -> false 
        | Interval (e1, e2) -> if (Endpoint.compare e e1 > 0) &&
                                  (Endpoint.compare e2 e > 0) then true 
                               else false

    let intersect i1 i2 =
      let max x y = if Endpoint.compare x y >= 0 then x else y in 
      let min x y = if Endpoint.compare x y <= 0 then x else y in
                                       
        match i1, i2 with 
          Empty, _ | _, Empty -> Empty 
        | Interval (e1, e2), Interval (e11, e12) -> 
            create (max e1 e11) (min e2 e12)

    let tostring = function 
          Empty -> "[]"
        | Interval (e1, e2) -> "[" ^ Endpoint.tostring e1 ^ ", " ^ Endpoint.tostring e2 ^ "]"
  end;;
  

  module IntInterval = Interval (
    struct
      type t = int 
      let compare e1 e2 = Int.compare e1 e2 

      let tostring e = string_of_int e
    end
  );;

  module StringInterval = Interval (
    struct
      type t = string 

      let compare e1 e2 = String.compare e1 e2 

      let tostring e = e;;
    end
  );;