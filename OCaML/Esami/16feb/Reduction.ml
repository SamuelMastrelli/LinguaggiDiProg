open Str;;

module ArithExpr =
  struct
      type expr =   N of float | U of op * expr | B of (expr * op * expr) and 
            op = Plus | Min | Times | Div 

      let op_of_string = function
          "+" -> Plus 
        | "-" -> Min 
        | "*" -> Times 
        | "/" -> Div
        | _ -> raise (Invalid_argument "Not an operator")

      let string_of_op = function
          Plus -> "+"
        | Min -> "-"
        | Times -> "*"
        | Div -> "/"

      let is_sign = function
        "+" | "-" | "*" | "/" -> true 
       | _ -> false 


      let expr_of_string s =
        let rec e_of_s ls le =
            match ls with 
                [] -> List.hd le 
              | h::tl -> if is_sign h then 
                           let e1 = List.hd le and 
                               le = List.tl le in 
                            if le <> [] then 
                              let e2 = List.hd le and 
                                  le = List.tl le in 
                                e_of_s tl ((B (e1, (op_of_string h), e2)) :: le )
                            else
                               e_of_s tl ( (U ((op_of_string h), e1)) :: le)

                          else
                             e_of_s tl ((N (float_of_string h)) :: le)
         in e_of_s (List.rev (Str.split (Str.regexp ("")) s) ) []

      let rec to_string = function 
         N n -> string_of_float n 
       | U (op, exp) -> (string_of_op op) ^ " " ^ (to_string exp)
       | B (e1, op, e2) -> "(" ^ (to_string e1) ^ " " ^ string_of_op op ^" " ^ (to_string e2) ^ ")"

      let rec step exp =
        match exp with 
            N n -> N n 
          | U (op, exp) -> U (op, step exp)
          | B (N n, op, N n1) ->( match op with 
                                   Plus -> N (n +. n1)
                                 | Min -> N (n -. n1)
                                 | Times -> N (n *. n1)
                                 | Div -> N (n /. n1) )
          | B (e1, op, e2) -> B (step e1, op, step e2)


      let rec print_step ex = 
          print_string (to_string ex ^ "\n") ;
          match ex with
              N _ -> ()
            | _ -> print_step (step ex)


      let print_evaluation s = print_step (expr_of_string s) 
                                  
                                  

  end;;