-module(ring).
-export([start/3]).

start(M, N, Msg) -> 
    create_ring(M, N, Msg, []).

create_ring(M, 0, Msg, Pids) -> send(M, Msg, Pids);
create_ring(M, N, Msg, []) -> create_ring(M, N-1, Msg, [self()]);
create_ring(M, N, Msg, Pids) -> create_ring(M, N-1, Msg, [spawn(fun() -> loop() end) | Pids]).


send(0, _, [Pid|Pids]) -> Pid ! {quit, Pids},
                            io:format("~p invia quit a ~p~n", [self(), Pid]);
send(M, Msg, [Pid|Pids]) ->
    io:format("~p invia ~p a ~p~n", [self(), Msg,  Pid]),
    Pid ! {msg, Msg, Pids},
    receive
        {msg, Msg, _} -> 
            send(M-1, Msg, [Pid|Pids])
    end.

loop() ->
    receive
        {msg, Msg, [Pid|Pids]} ->
            io:format("~p invia ~p a ~p~n", [self(), Msg,  Pid]),
            Pid ! {msg, Msg, Pids},
            loop();
        {quit, [Pid|Pids]} -> 
            io:format("~p invia quit a ~p~n", [self(), Pid]),
            Pid ! {quit, Pids}
    end.

