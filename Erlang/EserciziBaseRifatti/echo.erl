-module(echo).
-export([start/0, print/1, stop/0]).

start() -> register(server, spawn(fun() -> loop() end)).

print(Term) -> server ! {print, Term}.

stop() -> exit(whereis(server), "Stop").

loop() ->
    receive
        {print, Term} -> io:format("~p~n", [Term]), loop();
        {stop} -> io:format("EXIT SERVER~n");
        Any -> io:format("ERROR: ~p~n", [Any]) 
    end.