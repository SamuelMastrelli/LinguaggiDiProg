-module(server).

init() ->
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
            
 
    end