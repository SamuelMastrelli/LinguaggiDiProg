-module(sieve).
-export([init/1]).


init(N) ->
    group_leader(whereis(user), self()),
    receive
        {init, Next, Server, first} -> loop_first(N, Next, Server);
        {init, Next, First, notFirst} -> loop(N, Next, First)
    end.

loop(N, Next, First) ->
    receive
        {pass,M} when M == N -> Next ! {pass, M}, loop(N, Next, First);
        {pass, M} when M rem N == 0-> First ! {res, false}, loop(N, Next, First);
        {pass, M} -> Next ! {pass, M}, loop(N, Next, First)
    end.

loop_first(N, Next, Server) ->
    receive
        {pass, _} -> Server ! {res, true}, loop_first(N, Next, Server);
        {new, M} when M == N -> Next ! {pass, M}, loop_first(N, Next, Server);
        {new, M} when M rem N == 0 -> Server ! {res, false}, loop_first(N, Next, Server);
        {new, M} ->  Next ! {pass, M}, loop_first(N, Next, Server);
        {res, Bool} ->  Server ! {res, Bool}, loop_first(N, Next, Server)

    end.