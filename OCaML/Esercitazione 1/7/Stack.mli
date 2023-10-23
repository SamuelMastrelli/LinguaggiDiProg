module type Stack =
    sig
      type 'a stack
      exception EmptyStackException
      val empty : unit -> 'a stack 
      val push : 'a stack -> 'a -> 'a stack 
      val pop : 'a stack -> 'a * 'a stack 
      val top : 'a stack -> 'a
      val  isEmpty : 'a stack -> bool 
    end;;