-module(client).
-export([is_prime/1, init/1, close/0]).

init(Server) -> 
    group_leader(whereis(user), self()),
    register(client, self()),
    loop(Server).

loop(Server) ->
    receive 
        {new, N} -> Server ! {new, N}, wait(N), loop(Server);
        {close} -> Server ! {quit}
    end.

is_prime(N) ->
    client ! {new, N}.

close() ->
    client ! {close}.

wait(N) ->
    receive
        {result, tooLarge} ->  io:format("~p is uncheckable, too big value~n", [N]);
        {result, Res} -> io:format("is ~p prime? ~p~n", [N, Res])
    end.