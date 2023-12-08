-module(server).
-export([init/0]).

init()->
    group_leader(whereis(user), self()),
    io:format("Server started~n"),
    loop([], []).


loop(First, Second) ->
    receive
        {mm1, F, _} when length(Second) == 0 -> 
            io:format("Received ~p from ~p~n", [F, mm1]),
            loop(F, Second);
        {mm1, F, Orig} -> 
            io:format("Received ~p from ~p~n", [F, mm1]),
            io:format("Is ~p palindrome? ~p~n", [Orig, (F == Second)]), 
            loop([], []);
        {mm2, S, _} when length(First) == 0 ->
            io:format("Received ~p from ~p~n", [S, mm2]),
            loop(First, S);
        {mm2, S,  Orig} -> 
            io:format("Received ~p from ~p~n", [S, mm2]),
            io:format("Is ~p palindrome? ~p~n", [Orig, (S == First)]), 
            loop([], [])
    end.
