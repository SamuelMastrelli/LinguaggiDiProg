import scala.util.parsing.combinator._

object ArithmeticParser extends JavaTokenParsers {
    
    def exp : Parser[String] =  decimalNumber ^^ {_.toString} | term

    def op = ("+" | "-" | "*" | "/") ^^ {
        case "+" => (_:Int) + (_:Int)
        case "-" => (_:Int) - (_:Int)
        case "*" => (_:Int) * (_:Int)
        case "/" => (_:Int) / (_:Int)
    }

    def term : Parser[String] = "(" ~> number ~ op ~ number <~ ")" ^^ {case n1~ o ~ n2 => o(n1, n2).toString} |
               "(" ~> number ~ """[\+\-\/\*]""".r ~ term <~")" ^^ 
                        {case n ~ o ~ t => "(" + n + " " + o + " " + t +")"} |
                "(" ~> term ~ """[\+\-\/\*]""".r ~ number <~")" ^^ 
                        {case t ~ o ~ n => "(" + t + " " + o + " " + n +")"} |
                "(" ~> term ~ """[\+\-\/\*]""".r ~ term <~")" ^^ {
        case t ~ o ~ t1 => "(" + t + " " + o + " " + t1 + ")"
    }
                   
                 

    def number = decimalNumber ^^ {_.toInt} | "-" ~> decimalNumber ^^ {-_.toInt}

}

object StepByStepEvaluator {

    def main(args: Array[String]) : Unit= {
        val lines = scala.io.Source.fromFile("src/main/scala/input.txt").mkString
        for(line <- lines.split("\n")) 
            parse(line)
    } 

    def parse(lines: String) : Unit = {
        ArithmeticParser.parseAll(ArithmeticParser.exp, lines) match {
            case ArithmeticParser.Success(res, _) => {
                println(res)
                if (res.split(" ").length > 1)  parse(res)
            }
            case x => println(x)
        }
    }
}