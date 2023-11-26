-module(slaves).
-export([start/0]).

start() -> spawn_link(fun() -> loop() end).

loop() ->
    receive
        {_, die} -> exit(self(), terminated);
        {N, Mex}-> io:format("Salve ~p print ~p~n", [N, Mex]), loop()
    end.