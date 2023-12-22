import scala.collection.mutable.ListBuffer

class editor  extends UndoRedo with debug {
    var line = new ListBuffer[Char]()

    var cursor = 0;

    def printLine = {
        val tol = line.toList
        tol.foreach(x => {print(x)})
        println("")
    }

    private def x_p = {
        line.remove(cursor)
        cursor = if (cursor != 0) cursor - 1
                 else cursor
    }

    private def i_p (c: Char) = {
        if (line.length > cursor) {
            line.insert(cursor+1, c) 
            cursor += 1
        }

        else line.append(c)
    }
    
    def i (c : Char) = {
        i_p(c)
        printWithCursor(cursor)
        add(line, cursor)
    }

    def x = {
        if(cursor > 0) x_p
        printWithCursor(cursor)
        add(line, cursor)
    }

    def iw (s: String) = {
        for(char <- s.toList) {
            i_p(char)
        }
        i_p(' ')
        printWithCursor(cursor)
        add(line, cursor)

    }

    def dw :Unit = {
        if(cursor > 0) {
            x_p
            var possibleLength = List.range(0, cursor+1).reverse
            for(ind <- possibleLength) {
                if (line.toList(ind) == ' ') {
                    cursor = if(cursor == 0) cursor
                            else cursor - 1
                    printWithCursor(cursor)
                    
        add(line, cursor)
                    return
                }
                x_p
            }
            printWithCursor(cursor)
            
add(line, cursor)
        }
        
    }

    def l (n : Int) : Unit= {
        for (i <- 0 to n+1) {
            if(cursor == line.length - 1) {
                printWithCursor(cursor)
                
    add(line, cursor)
                return
            } 
            else cursor += 1
        }
        printWithCursor(cursor)
        add(line, cursor)
    }

    def h (n : Int) : Unit= {
        for (i <- 0 to n+1) {
            if(cursor == 0) {
                printWithCursor(cursor)
                add(line, cursor)
                return
            } 
            else cursor -= 1
        }
        printWithCursor(cursor)
        add(line, cursor)
    }

    override def u = {
        if(lasts.length > 0) {
            redos = lasts.head :: redos
            lasts = lasts.tail
            lasts match  {
                case (c, curs: Int) :: tl => {
                    line = new ListBuffer[Char]()
                    line.addAll(c.iterator) 
                    cursor = curs 
                    lasts = tl 
                    }
                case Nil => {line = new ListBuffer[Char] 
                             cursor = 0}
            }
        }
        printWithCursor(cursor)
    }


    override def ctrlr  = {
        redos match {
            case (c, curs: Int) :: tl => {
                var NewLine = new ListBuffer[Char]()
                NewLine.addAll(c.iterator)
                line = NewLine
                cursor = curs
                redos = tl 
                lasts = (c, curs) :: lasts
            }
            case Nil => printWithCursor(cursor)
        }

        printWithCursor(cursor)
    }

}