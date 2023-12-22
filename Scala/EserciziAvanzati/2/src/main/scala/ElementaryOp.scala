import scala.util.parsing.combinator._


class ElementaryOpParser extends JavaTokenParsers {

    private var maxLength = 0

    private var lastOp = (_:Int) + (_:Int)

    private var cumulativeRes = 0

    def parseLine(s: String) = {
        if(maxLength  < s.length) maxLength = s.length 
        parseAll(term, s) match {
            case Success(res, _) => if (s.contains('=')) println(res)
            case x => println(x)
        }
    }

    def term: Parser[Int] = (number ~ op) ^^ {case n ~ newOp => cumulativeRes=lastOp(cumulativeRes, n); lastOp = newOp; cumulativeRes} | 
                            (number <~ "=") ^^ {case n => lines; lastOp(cumulativeRes, n)}
                            
    def number = decimalNumber ^^ {_.toInt}
                        
    def op : Parser[(Int, Int) => Int] = "+" ^^ {_ => ((x:Int, y:Int) => x + y)}| "-" ^^ {_ => ((x:Int, y:Int) => x - y)} 


    private def lines = {
        (1 to maxLength).foreach( _ => print("-")); println("")}
}