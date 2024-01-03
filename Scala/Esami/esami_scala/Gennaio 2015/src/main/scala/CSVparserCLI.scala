import scala.util.parsing.combinator._
import scala.collection.mutable.ListBuffer


object CSVparser extends JavaTokenParsers {

    private val header = new ListBuffer[String]() 
    private val mapping = new scala.collection.mutable.HashMap[String, ListBuffer[String]]()
    private val mappingLines = new scala.collection.mutable.HashMap[Int, List[String]]()

    private val maplength = new scala.collection.mutable.HashMap[String, Int]()

    private var currentLine = 0


    def parsefile(lines: String) = {
        val l = lines.split("\n")
        parseHeader(l(0))
        println(l.slice(1, l.length).mkString("\n"))
        for (line <- l.slice(1, l.length)) parse(entry, line)
        prettyPrint
        currentLine = 0
    }

    def parseHeader(t: String) = parseAll(headers, t)

    def headers = rep1sep(value, ",") ^^ {case l => header.appendAll(l)}

    def entry = rep1sep(value, ",") ^^ {case l => 
        mappingLines.put(currentLine, l); currentLine += 1
        (0 to (header.length - 1)).foreach{
            n => 
            val head = header.apply(n)
            val prev = mapping.get(head).getOrElse[ListBuffer[String]](new ListBuffer[String]())
            val value = l(n)
            if (maplength.getOrElse[Int](head, 0) < value.length + 2) 
                maplength.put(head, value.length + 2)
            prev.append(value)
            mapping.put(head, prev)
        }
    }

    def value = """[^,]+""".r


    def prettyPrint = {
        printLines
        printHeaders
        printLines
        printEntries
        printLines
    }


    def printLines = {
        var length = 0 
        for(value <- maplength.values) {
            length += value
        }
        (0 to length + (header.length * 2)).foreach( 
            _ => print("-")
        )
        println("")
    }

    def printHeaders = {
        for (h <- header) {
            print("| " + h)
            spaces(h, h)
        }
        println("|")
    }

    def spaces(s: String, s1: String) = {
        (0 to (maplength.get(s).getOrElse[Int](0) - s1.length) - 1).foreach(
            _ => print(" ")
        )
    }

    def printEntries = {
        (0 to mappingLines.size-1).foreach { h =>
            val record = mappingLines.getOrElse[List[String]](h, List[String]())
            for((s, c) <- record.zip(header)) {
                print("| " + s )
                spaces(c, s)
            }
        
            println("|") 
        }
    }
}

object Main {

    def main(args: Array[String]) :Unit = {
        val lines = scala.io.Source.fromFile("books.csv").mkString
        CSVparser.parsefile(lines)
    }
}