-module(joseph).
-export([joseph/2]).

joseph(N, K) ->
    io:format("In a circle of ~p people, killing number ~p~n", [N, K]),
    PIDS = joseph(N, K, []),
    Coppie = lists:zip(PIDS, tl(PIDS) ++ [hd(PIDS)]), init(Coppie),
    loop().



joseph(0, _, Hebrews) -> Hebrews;
joseph(N, K, Hebrews) -> 
    Master = self(),
    joseph(N-1, K, [spawn(fun() -> hebrew:start(N, K, Master) end)|Hebrews]).


loop() -> 
    receive
        {last_survivor, N} -> io:format("Joseph is the hebrew in position ~p~n", [N]);
        _ -> io:format("error reveived~n")
    end.


init(Coppie) -> lists:foreach((fun({Pid, Next}) -> Pid ! {next, Next} end), Coppie), 
                {Prev, _} = lists:last(Coppie),
                {Pid, _} = hd(Coppie), Pid ! {prev, Prev, mex, "Who Will Die?", step, 1}.