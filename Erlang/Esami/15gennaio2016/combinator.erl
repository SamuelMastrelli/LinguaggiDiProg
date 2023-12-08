-module(combinator).
-export([start/2]).

start(N, M) ->
    start(N, M, []).


start(0, M, Slaves) -> 
    register(master, spawn(fun() -> loop(Slaves, M) end));
start(N, M, Slaves) -> 
    start(N-1, M, [spawn(fun() -> generator:loop(1) end)|Slaves]).


loop(Slaves, M) ->
    io:format("~n"),
    print(lists:reverse(Slaves)),
    update(Slaves, M, 1, false).

update([], _, _, _)-> io:format("ERROR ~n");
update(_, _, _, true) -> io:format("~n");
update(Sls, M, C, _) ->
    Sl = contactSlave(Sls, C),
    receive
        {number, N} -> case N == M of 
                            true -> 
                                Sl ! {update, 1}, update(Sls, M, C + 1, forAll(Sls, M));
                            false -> 
                                Sl ! {update, N + 1}, print(lists:reverse(Sls)), update(Sls, M, 1, forAll(Sls, M))
                        end;
        Any -> io:format("ERROR ~p~n", [Any])
    end.


contactSlave(Sls, C) ->
    Sl = lists:nth(C, Sls),
    Sl ! {show, self()}, Sl.

print([]) -> io:format("~n");
print([Sl]) ->
    Sl ! {show, self()},
    receive
        {number, N} -> 
            io:format("~p", [N]),
            print([])
    end;

print([Sl|Sls]) ->
        Sl ! {show, self()},
        receive
            {number, N} -> 
                io:format("~p, ", [N]),
                print(Sls)
        end.



forAll(Slaves, M) -> lists:all((fun(X) -> 
    X ! {show, self()}, 
    receive
        {number, N} -> N == M;
        _ -> false
    end end), Slaves).
    