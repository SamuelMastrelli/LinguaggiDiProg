open Stack;;

module StackList : Stack = 
  struct
      type 'a stack = {s : 'a list}
      exception EmptyStackException 

      let empty () = {s = []}

      let push st el = {s = el::st.s}

      let pop st = 
        match st.s with 
            [] -> raise EmptyStackException
          | h::tl -> (h, {s = tl})
      
      let top st =
        match st.s with 
            [] -> raise EmptyStackException
          | h::_ -> h
        
      let isEmpty st =
        match st.s with 
            [] -> true 
          | _ -> false
      
      

  end;;