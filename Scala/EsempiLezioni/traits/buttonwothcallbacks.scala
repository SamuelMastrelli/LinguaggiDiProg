class ButtonWithCallBacks(val label: String, val clickedCallbacks: List[()  => Unit]) {
    require(clickedCallbacks != null, "Callbacks list can't be null!")

    def this(label: String, clickedCallback: () => Unit) = 
        this(label, List(clickedCallback))

    def this(label: String) = {
        this(label, Nil)
        println("Warning: button has no click callbacks!")
    }

    def click()  = {
        clickedCallbacks.foreach(f => f())
    }
}