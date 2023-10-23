module TaylorApprox = 
struct

  let fact n =
      let rec fatc acc i =
          match i with 
             1 -> acc 
           | _ -> fatc (acc * i) (i-1)
      in fatc 1 n;;
  let sin x n =
      let rec sin acc i =
        match i with 
           0. -> x +. acc  
        |  _ -> let sign = if (int_of_float i) mod 2 = 0 then 1. else -1. in 
                sin (sign *. ((x ** (i*.2. +. 1.)) /. (float_of_int (fact (int_of_float(i *. 2. +. 1.)))))) (i -. 1.)
      in sin 0. n;;
  
end;;