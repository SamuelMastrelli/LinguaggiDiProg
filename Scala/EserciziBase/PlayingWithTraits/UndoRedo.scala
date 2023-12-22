import scala.collection.mutable.ListBuffer

trait UndoRedo {

    var lasts = List[(List[Char], Int)]()
    var redos = List[(List[Char], Int)]()


    def u : Unit


    def ctrlr  : Unit

    def add(line: ListBuffer[Char], cursor: Int) = {
        lasts = (line.toList, cursor) :: lasts 
    }


}