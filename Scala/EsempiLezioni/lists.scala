def map[A, B](f:A => B, list:List[A]): List[B] =
    list match {
        case Nil => Nil
        case h::tl => f(h) :: map[A, B](f, tl)
    }

def reduce[T](f:(T, T) => T, list:List[T]): T ={ 
    var acc = list.head; for (X <- list.tail if true) acc = f(acc, X); acc
}


def filter[T, Boolean](f:T => Boolean, list:List[T]): List[T] = {
    for {Y <- list if f(Y) == true} yield Y
}
    