-module(client).
-export([test/1]).

test(N) ->
    process_flag(trap_exit, true),
    echo:start(),
    link(whereis(server)),
    loop_test(N).

loop_test(0) -> 
    echo:stop(),
    receive
        {'EXIT', _, Reason} -> 
            io:format("Server terminated: ~p ~n",[Reason])
    end;
loop_test(N) -> 
    echo:print(N),
    timer:sleep(1000),
    loop_test(N-1).