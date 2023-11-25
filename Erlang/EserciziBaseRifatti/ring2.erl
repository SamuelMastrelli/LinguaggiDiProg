-module(ring2).
-export([start/3]).

start(M, N, Msg) ->
    set_up(M, N, Msg, []).

set_up(M, N, Msg, Pids) -> 
    Pid = spawn(fun() -> init(M) end),
    io:format("~p initiated ~n", [Pid]),
    Pid ! {init, N-1, [Pid|Pids]},
    Pid ! {msg, Msg},
    io:format("inviato ~p a ~p ~n", [Msg, Pid]).

init(M) ->
    receive
        {init, 0, Pids} -> 
            Rev = lists:reverse(Pids),
            loop(hd(Rev), M);
        {init, N, Pids} -> 
            Pid = spawn(fun() -> init(M) end),
            io:format("~p crea ~p ~n", [self(), Pid]),
            Pid ! {init, N-1, [Pid|Pids]},
            loop(Pid, M)
    end.

loop(_, 0) -> io:format("~p termina ~n", [self()]);

loop(Pid, M) ->
    receive
        {msg, Msg} ->
            Pid ! {msg, Msg},
            io:format("~p invia ~p a ~p~n", [self(), Msg, Pid]),
            loop(Pid, M-1)
    end.