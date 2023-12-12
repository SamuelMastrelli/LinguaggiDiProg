

import java.lang.StringBuilder


class Matrix(val rows: List[List[Int]]) {

    require(rows != null, "A matrix can't be null")
    require(rows.forall( x => x.length == rows.head.length), "A matrix must have rows of the same length.")

    def eq (m: Matrix) : Boolean = {
        rows equals m.rows
    }

    def copy (m: Matrix) = new Matrix(m.rows)

    def + (m: Matrix) = {   
        require(m.rows.length == rows.length && m.rows.forall(x => x.length == rows.head.length ), "Devono avere la stessa dimensione")
        var res : List[List[Int]] = List()
        for ((t, other) <- rows.zip(m.rows)) {
            var partial : List[Int]= List()
            for ((n1, n2) <- t.zip(other)) partial = (n1 + n2) :: partial 
            res = partial.reverse :: res
        }
        new Matrix(res.reverse)
    }

    def * (s: Int) = {
        new Matrix(rows.map( x => x.map( y => y * s)))
    }

    def transpose_matrix = new Matrix(rows.transpose)
    private def transpose : List[List[Int]] = {
        rows match {
            case Nil => Nil 
            case (h::Nil) :: tll => rows.map(_.head) :: Nil
            case _ => rows.map(_.head) :: (new Matrix(rows.map(_.tail))).transpose
        }

    }

    def vectProd (t: List[Int], o: List[Int]) : Int = {
        var res = 0
        for ((n1, n2) <- t.zip(o)) res += (n1 * n2) 
        res
    }


    def ** (m: Matrix) = rows.map( x => m.transpose_matrix.rows.map( y => vectProd(x, y)))


    private def max (n: Int, n2:Int) = {if (n > n2) n
                                        else n2}
    def norm = {
        var maxLists = rows.map( x => x.reduceLeft(max(_,_)))
        maxLists.reduceLeft(max(_,_))
    }

    override def toString = {
        var sb = new StringBuilder()
        for (row <- rows) {
            row.foreach(x => {sb.append(x)
                              sb.append(" ")})
            sb.append("\n")
        }
        sb.toString
    }
}