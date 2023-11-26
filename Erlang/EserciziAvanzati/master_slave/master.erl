-module(master).
-export([start/1, to_slave/2]).


start(N) -> 
    register(master, spawn(fun() -> loop() end)),
    master ! {start, N}.
    

to_slave(Mex, N) ->
    master ! {msg, N, Mex}.

loop() ->
    process_flag(trap_exit, true),
    receive
        {start, N} ->
            start_slaves(N), loop();
        {'EXIT', Slave, _} -> 
            [N|_] = get_keys(Slave),
            io:format("Master restarting slave ~p~n", [N]),
            put(N, slaves:start()), loop();
        {msg, N, Mex} -> 
            Sl = get(N),
            Sl ! {N, Mex}, loop()
    end.



start_slaves(0) -> io:format("Slaves initiated~n");
start_slaves(N) ->
    put(N, slaves:start()),
    start_slaves(N-1).