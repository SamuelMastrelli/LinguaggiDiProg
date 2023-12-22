object Main {
    def main(args : Array[String]) = {
        val lines = scala.io.Source.fromFile("src/main/scala/input.txt").getLines
        val parser = new CalcParserComb
        println("Ciao")
        for(line <- lines) {
            parser.parseAll(parser.expr, line) match {
                case parser.Success(res, _) => println(res)
                case x => println(x.toString)
            }
        }
    }
}