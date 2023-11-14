-module(counting).
-export([start/0, service/1, tot/0]).

start() -> register(server,  spawn(fun() -> loop(0, 0, 0, 0) end)).

service(Dumm) ->  server ! {Dumm}.

tot() -> server ! {tot}.

loop(D1, D2, D3, Tot) -> 
    receive
        {dummy1} -> io:format("Servizio 1~n"), loop(D1+1, D2, D3, Tot);
        {dummy2} -> io:format("Servizio 2~n"), loop(D1, D2+1, D3, Tot);
        {dummy3} -> io:format("Servizio 3~n"), loop(D1, D2, D3+3, Tot);
        {tot} -> io:format("~p, ~p, ~p, ~p ~n", [{dummy1, D1}, {dummy2, D2}, {dummy3, D3}, {tot, Tot+1}]),
                 loop(D1, D2, D3, Tot+1);
        {stop} ->io:format("Stop.")
     end.