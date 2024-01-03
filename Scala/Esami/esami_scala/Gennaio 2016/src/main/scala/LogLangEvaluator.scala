import scala.util.parsing.combinator._
import java.io._
import java.util.Scanner

trait Command 

case class Program(tasks: List[Task])
case class Task(name: String, operations: List[Command]) 
case class Remove(name: String) extends Command
case class Rename(n1: String, n2: String) extends Command
case class Merge(f1: String, f2: String, f3: String) extends Command
case class Backup(toSave: String, backup: String) extends Command


object LogLangInterpreter {

    def exec (p: Program) = {
        p.tasks.foreach {
            t => 
            println("Task "+ t.name)    
            var count = 0
            t.operations.foreach{
                op =>
                print("[op"+count+"]")
                execCommand(op)
                count += 1
            }
            
        }
    }

    private def execCommand(c: Command) = {
        c match {
            case Remove(f) => println(" "+new File(f).delete())
            case Rename(old, newFile) => println(""+new File(old).renameTo(new File(newFile)))
            case Merge(f1, f2, f3) => {
                val sc1 = new Scanner(new File(f1))
                val sc2 = new Scanner(new File(f2))
                var dest = new FileWriter(f3)
                while(sc1.hasNext()) dest.write(sc1.next())
                sc1.close()
                while(sc2.hasNext()) dest.write(sc2.next())
                sc2.close()
                dest.close()
                println(" "+true)
            }
            case Backup(f1, f2) => {
                var dest = new FileWriter(f2)
                val sc = new Scanner(f1)
                while(sc.hasNext()) dest.write(sc.next())
                sc.close()
                dest.close()
                println(" "+true)
            }
        }
    }
}

object LogLangParser extends JavaTokenParsers{


    def program : Parser[Program] = rep(task) ^^ {case l => Program(l)}

    def task = "task" ~> name ~ ("{" ~> rep(operation) <~ "}")^^ {case n ~ op => Task(n, op)}

    def name = """[a-zA-Z]+""".r

    def operation = "remove" ~> fileName ^^ {case f => Remove(f)} |
                    "rename" ~> fileName ~ fileName ^^ {case n1 ~ n2 => Rename(n1, n2)} |
                    "merge" ~> fileName ~ fileName ~ fileName ^^ {case f1 ~ f2 ~ f3 => Merge(f1, f2, f3)} |
                    "backup" ~> fileName ~ fileName ^^ {case f1 ~ f2 => Backup(f1, f2)}

    def fileName = """[\"]""".r ~> """[\.\+\-a-z]+""".r <~ """[\"]""".r
}

object Main {
    def main(args: Array[String]): Unit = {
        val lines = scala.io.Source.fromFile(args(0)).mkString
        LogLangParser.parseAll(LogLangParser.program, lines) match {
            case LogLangParser.Success(res, _) => LogLangInterpreter.exec(res)
            case x => println(x)
        }
    }
}