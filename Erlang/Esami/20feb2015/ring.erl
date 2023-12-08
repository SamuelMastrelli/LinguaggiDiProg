-module(ring).
-export([start/2, send_message/1, send_message/2, stop/0, create_ring/3]).

start(N, Fs) ->
    register(sender, spawn_link(?MODULE, create_ring, [N, Fs, self()])),
    receive
        ok -> ok 
        after 5000 -> io:format("Error.~n")
    end.

create_ring(1, [F|_], Master) -> 
    Master ! ok, 
    loop_last(sender, F);
create_ring(N, [F|Fs], Master) ->
    Next = spawn_link(?MODULE, create_ring, [N-1, Fs, Master]),
    loop(Next, F).

send_message(Msg) ->  send_message(Msg, 1).
send_message(Msg, N) ->
    sender ! {msg, Msg, N}.

stop() -> sender ! {stop}.

loop_last(Sender, F) ->
    receive
        {stop} -> exit(normal), unregister(sender);
        {msg, Msg, 1} ->
            io:format("Ok, ~p~n", [F(Msg)]), loop_last(Sender, F);
        {msg, Msg, N} ->
            Sender ! {msg, F(Msg), N-1}, loop_last(Sender, F)
    end.

loop(Next, F)->
    receive
        {stop} -> Next ! {stop};
        {msg, Msg, N} ->
            Next ! {msg, F(Msg), N}, loop(Next, F)
    end.