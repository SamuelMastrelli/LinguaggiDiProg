-module(server).
-export([init/0]).

init() ->
    group_leader(whereis(user), self()),
    io:format("Server started~n"),
    loop().

loop() ->
    receive
        {mm1, {F, _}} -> 
            io:format("Received ~p ~n", [F]),
            put(first, F), loop();
        {mm2, {S, Orig}} -> 
            io:format("Received ~p ~n", [S]),
            F = get(first),
            io:format("Is palindrome ~p? ~p~n", [Orig, F == S]), loop()
    end.