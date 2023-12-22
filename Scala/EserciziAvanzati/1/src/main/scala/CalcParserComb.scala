import scala.util.parsing.combinator._

class CalcParserComb extends JavaTokenParsers {
    private val binaryOp = Map( "+" -> ((_:Double) + (_:Double)), "-" -> ((_:Double) - (_:Double)),
                              "*" -> ((_:Double) * (_:Double)), "/" -> ((_:Double) / (_:Double)))
    private val unaryOp = Map( "^" -> {x: Double => x * x}, "sqrt" -> (math.sqrt(_)), "sin" -> (math.sin(_)),
                             "cos" -> (math.cos(_)), "tan" -> (math.tan(_)))
  
    private var variables = Map[String, Double]()

    def expr : Parser[Double] = assign | binary | unary | term 
    def binary = (term ~ op ~ term) ^^ { case n1 ~ opr ~ n2 => opr.get(n1, n2)}
    def term = decimalNumber ^^ {_.toDouble} | floatingPointNumber ^^ {_.toDouble}| variable ^^ {variables.get(_).get} | ("(" ~> expr <~")") ^^ {_.toDouble}
    def unary = {( "^" ~> "(" ~> expr <~ ")" ) ^^ {unaryOp.get("^").get(_)} |
                ( "sqrt" ~> "(" ~> expr <~ ")" ) ^^ {unaryOp.get("sqrt").get(_)} |
                ( "sin" ~> "(" ~> expr <~ ")" ) ^^ {unaryOp.get("sin").get(_)} |
                ( "cos" ~> "(" ~> expr <~ ")" ) ^^ {unaryOp.get("cos").get(_)} |
                ( "tan" ~> "(" ~> expr <~ ")" ) ^^ {unaryOp.get("tan").get(_)} |
                ( "-" ~> term ) ^^ {-_.toDouble} |
                ( "+" ~> term ) ^^ {_.toDouble}
    }
    def variable = "[a-zA-Z]".r
    def assign = (variable ~ "=" ~ expr) ^^ {case v ~ _ ~ ex => {variables = variables + (v -> ex)
                                                                 ex}} 
    def op = ("+" | "-" | "*" | "/") ^^ {binaryOp.get(_)}


}

