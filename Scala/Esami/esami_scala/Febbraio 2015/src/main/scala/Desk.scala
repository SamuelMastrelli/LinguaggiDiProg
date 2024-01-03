import scala.util.parsing.combinator._
import scala.collection.mutable




object DeskParser extends JavaTokenParsers {

    private val env = new mutable.HashMap[Char, Int]()

    def program : Parser[mutable.Map[Char, Int]] = "print" ~> expr ~ ("where" ~> rep1sep(assignment, ",")) ^^
                {case f ~ e => println(f()); env}

    def expr : Parser[() => Int] = (( (num ~ ("+" ~> expr)) | 
        (x ~ ("+" ~> expr))) ^^ 
        {case f1 ~ f2 => () => f1() + f2()} | x | num)

    def x = """[a-z]""".r ^^ {c => () => env(c.charAt(0))}

    def num = wholeNumber ^^ {n => () => n.toInt}

    def assignment = """[a-z]""".r ~ ("=" ~> wholeNumber) ^^ {case v ~ n => env(v.charAt(0)) = n.toInt}
 
}


object Main {
    def main(args: Array[String]) : Unit = {
        args.foreach {
            string =>
            DeskParser.parseAll(DeskParser.program, string) match {
                case DeskParser.Success(res, _) => println(res)
                case x => println(x)
            }
        }
    }
}