-module(ring2).
-export([start/3, init/3, loop/0]).

start(M, N, Message) ->
    set_up_ring(N, M, Message, []).

set_up_ring(0, M, Mex, [Pid|Pids]) -> Pid ! {msg, Mex, Pids, M};
set_up_ring(N, M, Mex, []) -> 
    io:format("First process ~p~n", [self()]),
    set_up_ring(N-1, M, Mex, [self()]);
set_up_ring(N, M, Mex, Pids) ->
    Pid = (spawn(?MODULE, init, [N, M, Mex])),
    io:format("~p initiated ~p~n", [self(), Pid]),
    Pid ! {init, [Pid|Pids]}.




init(N, M, Message) -> 
    receive
        {init, Pids} -> 
            set_up_ring(N-1, M, Message, Pids),
            loop();
        Any -> io:format("ERROR ~p~n", [Any])
    end.

loop() -> 
    receive 
        {msg, _, _, 0} -> io:format("End ~p~n", [self()]);
        {msg, Mex, [Pid|Pids], M} ->
            io:format("~p riceve ~p~n", [self(), Mex]),
            Pid ! {msg, Mex, Pids, M-1},
            io:format("~p invia ~p a ~p~n", [self(), Pid, Mex])
    end.