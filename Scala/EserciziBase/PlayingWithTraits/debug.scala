trait debug {

    def printWithCursor (n: Int) = {
        for (i <- 0 to n-1) {
            print(" ")
        }
        print("v\n")
        printLine
    }

    def printLine : Unit

}