object Goldbach {
    def goldbach(n: Int) : List[(Int, Int)] = {
        val primes = for {X <- List.range(2, n) if is_prime(X)} yield X
        def gold (res : List[(Int, Int)], primes : List[Int]): List[(Int, Int)] = {  
            primes match {
                case h::tl => if (primes.exists((_ == (n - h)))) gold(res ::: List((h, (n-h))), tl)
                              else gold(res, tl)
                case Nil =>   res
            }
        }

        gold(List(), primes)
    }

    private val is_prime = {
        (n: Int) =>
        val divisors = {
            (d: Int) =>
            for {X <- List.range(2, Math.sqrt(d).toInt + 1) if (d % X == 0)} yield X
        }
        divisors(n).length == 0
    }

    def goldbach_list(n: Int, m:Int) = 
        List.range(n, m).map((x) => goldbach(x))
}