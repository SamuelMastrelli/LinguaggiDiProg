object FunScala {
    def is_palindrome(s: String): Boolean = {
        val trimmed = s.trim.toLowerCase.split("[\\p{Punct}\\s]+").mkString
        trimmed.equals(trimmed.reverse)
    }


    def is_an_anagram(s: String, list:List[String]): Boolean = {
        def is_anagram (s1: String) (s2: String) = {
            val sorted1 = s1.split("").toList.sortWith((s1:String, s2:String) => (s1.compareTo(s2) < 0))
            val sorted2 = s2.split("").toList.sortWith((s1:String, s2:String) => (s1.compareTo(s2) < 0))
            sorted1.equals(sorted2)
        }

        list.exists(is_anagram(s))

    }

    def factors(n: Int) : List[Int] = {
        val is_prime = (X: Int) => {
            val divisors = (X: Int) =>
                for {Y <- List.range(2, math.sqrt(X).toInt + 1) if (X % Y == 0) } yield X
            divisors(X).length == 0
        }

        for {X <- List.range(2, n/2.toInt) if (is_prime(X) && (n % X == 0))} yield X
    }

    def is_proper(X: Int) : Boolean = {
        val divisors = for {Y <- List.range(1, X/2.toInt + 1) if (X % Y == 0)} yield Y
        divisors.sum == X
    }


}