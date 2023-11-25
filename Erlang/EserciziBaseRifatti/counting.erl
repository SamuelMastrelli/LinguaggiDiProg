-module(counting).
-export([start/0]).

start() -> register(count, spawn(fun() -> loop(0, 0, 0, 0) end)).

loop(D1, D2, D3, Tot) ->
    receive
        {dummy1} -> loop(D1+1, D2, D3, Tot);
        {dummy2} -> loop(D1, D2+1, D3, Tot);
        {dummy3} -> loop(D1, D2, D3+1, Tot);
        {tot} -> io:format("~p~n", [[{dummy, D1}, {dumm2, D2}, {dummy3, D3}, {tot, Tot+1}]]),
                loop(D1, D2, D3, Tot+1);
        {stop} -> io:format("terminated~n");
        Any -> io:format("ERROR ~p~n", [Any]), loop(D1, D2, D3, Tot)
    end.