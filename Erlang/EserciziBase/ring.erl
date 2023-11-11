-module(ring).
-export([start/3, loop/0]).
 
start(M, N, Message) -> 
    start(M, N, Message, []).

start(M, 0, Message, Pids) -> send(M, Message, Pids);
start(M, N, Message, []) -> start(M, (N-1), Message, [self()]);
start(M, N, Message, Pids) -> start(M, (N-1), Message, [(spawn(ring, loop, []))|Pids]).

send(0, _, [Pid|Pids]) ->
    io:format("~p sends stop to ~p~n", [self(), Pid]), 
    Pid ! {stop, Pids}; 
send(M, Message, [Pid|Pids]) ->
    io:format("~p sends ~p to ~p~n", [self(),Message, Pid]),
    Pid ! {Message, Pids},
    receive
        {Mex, _} ->  send((M-1), Mex, [Pid|Pids]);
        Any -> io:format("ERROR: ~p~n", [Any])
    end.

loop() ->
    receive
        {Message, [Pid|Pids]} -> 
                io:format("~p sends ~p to ~p~n", [self(), Message, Pid]),    
                Pid ! {Message, Pids}, loop();

        {stop, [Pid|Pids]} ->  io:format("~p sends stop to ~p~n", [self(), Pid]),    
        	     Pid ! {stop, Pids};

        Any -> io:format("ERROR : ~p~n", [Any])
    end.
