module type GroupADT =
    sig
      type t 
      val set : t list
      val identity : t 
      val op : t -> t -> t 
    end