import scala.util.parsing.combinator._
import scala.collection.mutable.HashMap
import java.lang.IllegalArgumentException

trait Command 

case class Program(operations: List[Command])
case class Print(s: String) extends Command
case class VariableDeclaration(vr: String, value: Int) extends Command
case class Assignment(vr: String, initial: String, op: List[Command]) extends Command 

case class Conditional(value: String, ifNot0: List[Command], if0: List[Command]) extends Command
case class Loop(v: String, op: List[Command]) extends Command

trait Operation extends Command
case class Plus(op2: String) extends Operation
case class Minus(op2: String) extends Operation
case class Times(op2: String) extends Operation
case class Divide(op2: String) extends Operation 

case class Equal(op2: String) extends Operation
case class MoreThan(op2: String) extends Operation 
case class Or(op2: String) extends Operation 
case class And(op2: String) extends Operation 

object ArnoldCInterpreter {

    private var env = new HashMap[String, Int]
    private var stack = new scala.collection.mutable.Stack[Int](0)





    def exec(p: Program) : Unit = {
        p.operations.foreach {
            op => 
            op match {
                case Print(n) if (env.get(n) == None) => println(n) 
                case Print(variable) => println(env.get(variable).get)
                case VariableDeclaration(v, n) => env.put(v, n)
                case Assignment(v, initial, op) => {
                    if(initial.matches("""\d+""")) stack.push(initial.toInt)
                    else stack.push(env.get(initial).get)
                    exec(Program(op))
                    env.put(v, stack.pop())
                }
                case Conditional(v, ifNot0, if0) => {
                    if (env.get(v).get != 0) exec(Program(ifNot0))
                    else exec(Program(if0))
                }
                case Loop(v, op) => while(env.get(v).get != 0) exec(Program(op))
                case o: Operation => solve(o)
            }
        }
    }

    private def solve(o: Operation) = {
        o match {
            case Plus(n) if (n.matches("""\d+""")) => stack.push(stack.pop() + n.toInt)
            case Plus(variable) => stack.push(stack.pop() + env.get(variable).get)
            case Minus(n) if (n.matches("""\d+""")) => stack.push(stack.pop() - n.toInt)
            case Minus(variable) => stack.push(stack.pop() - env.get(variable).get)
            case Times(n) if (n.matches("""\d+""")) => stack.push(stack.pop() * n.toInt)
            case Times(variable) => stack.push(stack.pop() * env.get(variable).get)
            case Divide(n) if (n.matches("""\d+""")) => (stack.push(stack.pop() / n.toInt))
            case Divide(variable) => (stack.push(stack.pop() / env.get(variable).get))

            case Equal(n) if (n.matches("""\d+""")) => {
                if(stack.pop() == n.toInt) stack.push(1)
                else stack.push(0)
            }
            case Equal(variable) => {
                if(stack.pop() == env.get(variable).get) stack.push(1)
                else stack.push(0)
            }
            case MoreThan(n) if (n.matches("""\d+""")) => {
                if(stack.pop() > n.toInt) stack.push(1)
                else stack.push(0)
            }
            case MoreThan(variable) => {
                if(stack.pop() > env.get(variable).get) stack.push(1)
                else stack.push(0)
            }
            case And(n) if (n.matches("""\d+""")) => {
                val first = toBool(stack.pop())
                val second = toBool(n.toInt)
                if(first && second) stack.push(1)
                else stack.push(0)
            }
            case And(variable) => {
                val first = toBool(stack.pop())
                val second = toBool(env.get(variable).get)
                if(first && second) stack.push(1)
                else stack.push(0)
            }
            case Or(n) if (n.matches("""\d+""")) => {
                val first = toBool(stack.pop())
                val second = toBool(n.toInt)
                if(first || second) stack.push(1)
                else stack.push(0)
            }
            case Or(variable) => {
                val first = toBool(stack.pop())
                val second = toBool(env.get(variable).get)
                if(first || second) stack.push(1)
                else stack.push(0)
            }
        }
    }

    private def toBool(n: Int) ={
        n match {
            case c if c > 0 => true
            case _ => false
        }
    }

}


object ArnoldCParser extends JavaTokenParsers {

    def program : Parser[Program] =  "IT'S" ~> "SHOWTIME" ~> rep(command) <~ "YOU" <~ "HAVE" <~ "BEEN" <~ "TERMINATED" ^^ {Program} 
    def command : Parser[Command] = print | declaration | assignment | condition | loop 

    def print = "TALK"~>"TO"~>"THE"~>"HAND" ~>  (("""[\"]""".r  ~> """[a-zA-Z0-9]+""".r <~ """[\"]""".r ) ^^ {Print} |
                                       ("""[a-zA-Z0-9]+""".r) ^^ {Print})
    def declaration = "HEY"~>"CHRISTMAS"~>"TREE" ~> ("""[a-zA-Z0-9]+""".r <~ "YOU"<~"SET"<~"US"<~"UP") ~ decimalNumber ^^ {case v ~ value => VariableDeclaration(v, value.toInt)}
    def assignment = "GET"~>"TO"~>"THE"~>"CHOPPER" ~> ("""[a-zA-Z0-9]+""".r <~ "HERE"<~"IS"<~"MY"<~"INVITATION") ~
                     (decimalNumber| """[a-zA-Z0-9]+""".r) ~ rep(operation)  <~ "ENOUGH" <~ "TALK" ^^ {case v ~ n ~ l => Assignment(v, n.toString, l)}
    def operation = arith | logic

    def arith : Parser[Command] = plus | minus | times | divide 

    def plus : Parser[Command] = "GET"~>"UP" ~> """[a-zA-Z0-9]+""".r ^^ {Plus}
    def minus : Parser[Command] = "GET"~>"DOWN" ~> """[a-zA-Z0-9]+""".r ^^ {Minus}
    def times : Parser[Command]= "YOU'RE" ~> "FIRED" ~> """[a-zA-Z0-9]+""".r ^^ {Times}
    def divide : Parser[Command] = "HE" ~> "HAD" ~> "TO" ~> "SPLIT" ~> """[a-zA-Z0-9]+""".r ^^ {Divide}

    def logic : Parser[Command] = equal | moreThan | or | and 

    def equal : Parser[Command] = "YOU"~>"ARE"~>"NOT"~>"YOU"~>"YOU"~>"ARE"~>"ME" ~> """[a-zA-Z0-9]+""".r ^^ {Equal}
    def moreThan : Parser[Command] = "LET" ~> "OFF" ~> "SOME" ~> "STEAM" ~> "BENNET" ~> """[a-zA-Z0-9]+""".r ^^ {MoreThan}
    def or : Parser[Command] = "CONSIDER" ~> "THAT" ~> "A" ~> "DIVORCE" ~> """[a-zA-Z0-9]+""".r ^^ {Or}
    def and : Parser[Command] = "KNOCK"~>"KNOCK" ~> """[a-zA-Z0-9]+""".r ^^ {And}

    def condition : Parser[Command] = 
        ("BECAUSE" ~> "I'M" ~> "GOING"~>"TO" ~> "SAY" ~> "PLEASE" ~> """[a-zA-Z0-9]+""".r  ~ (rep(command) <~ "BULLSHIT") ~ (rep(command) <~ "YOU"<~"HAVE"<~"NO"<~"RESPECT" <~ "FOR" <~ "LOGIC")) ^^ {case v ~ lif ~ lelse => Conditional(v, lif, lelse)}
    def loop : Parser[Command] =    
        ("STICK"~>"AROUND" ~> """[a-zA-Z0-9]+""".r <~ "[") ~ ( rep(command) <~ "]" <~ "CHILL")^^ {case v ~ op => Loop(v.toString, op)}
        

}

object Main {
    def main(args: Array[String]) :Unit = {
        args.foreach {
            name => 
            val lines = scala.io.Source.fromFile(name).mkString

            ArnoldCParser.parseAll(ArnoldCParser.program, lines) match {
                case ArnoldCParser.Success(res, _) => ArnoldCInterpreter.exec(res)
                case x => println(x)
            }
        }
    }
}