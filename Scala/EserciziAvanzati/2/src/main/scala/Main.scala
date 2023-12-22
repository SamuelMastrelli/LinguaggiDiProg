import scala.collection.mutable.ListBuffer

object Main {
    def main(args: Array[String]) = {
        var lines = scala.io.Source.fromFile("src/main/scala/input.txt").getLines()
        var p = new ElementaryOpParser
        for(line <- lines) {
            if(line.isEmpty) {
                p = new ElementaryOpParser
            } else { println(line)
                     p.parseLine(line) }
        }
        
    }
}