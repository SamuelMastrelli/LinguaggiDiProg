-module(generator).
-export([loop/1]).


loop(N) ->
    receive
        {update, M} ->  loop(M);
        {show, Master} -> Master ! {number, N}, loop(N);
        Any -> io:format("ERROR ~p~n", [Any])
    end.
