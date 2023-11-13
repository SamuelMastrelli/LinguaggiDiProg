-module(server).
-export([start_server/0]).

start_server() -> spawn(fun() -> loop() end).

loop()-> 
    receive
        {print, Term} -> io:format("Print ~p~n", [Term]), loop()
    end.