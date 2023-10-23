open Stack;;

module PolishCalc (St : Stack) =
    struct
      type expr = 
        | V of int
        | Unary of op * expr
        | Binary of expr * op * expr 
        and 
        op = 
          | Sum 
          | Min 
          | Mult 
          | Pow 
          | Div

      let op_of_string = function
          "+" -> Sum 
        | "-"-> Min 
        | "*" -> Mult 
        | "**" -> Pow 
        | "/" -> Div 
        |  _ -> raise (Invalid_argument "Operatore non valido")
      
      let is_sign = function
         "+" | "-" | "*" | "/" | "**" -> true 
        | _ -> false 
        

      let expr_of_string s =
          let list = String.split_on_char ' ' s in 
            
          let rec ti ls stack=
              match ls with 
                  [] -> fst (St.pop stack) 
                | h::t -> match is_sign h with 
                              true -> let (e1, stack) = St.pop stack in
                                      if (St.isEmpty stack) then 
                                        ti t (St.push stack (Unary ((op_of_string h), e1) ))
                                      else
                                        let (e2, stack) = St.pop stack in
                                        ti t (St.push stack (Binary (e1, (op_of_string h),e2)))

                            | false -> ti t (St.push stack (V (int_of_string h)))
           in ti list (St.empty())         
             

      let powI b e =
        let rec pr acc i =
          match i with 
             0 -> acc 
           | _ -> pr (acc * b) (i-1)
        in pr 1 e
      let rec eval exp =
          match exp with
              V n -> n 
            | Unary (op, e) -> (match op with 
                                  Sum -> eval e 
                                | Min -> 0 - (eval e)
                                | _ -> failwith "InvalidExpression" )
            | Binary (e1, op, e2) -> match op with 
                                        Sum -> ((eval e1) + (eval e2))
                                      | Min -> ((eval e1) - (eval e2))
                                      | Mult -> ((eval e1) * (eval e2))
                                      | Div -> ((eval e1) / (eval e2))
                                      | Pow -> powI (eval e1) (eval e2)

      

    end;; 