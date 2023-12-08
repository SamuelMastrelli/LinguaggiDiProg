-module(mm).
-export([init/2]).

init(Name, Server) ->
    group_leader(whereis(user), self()),
    io:format("Starting ~p~n", [Name]),
    loop(Name, Server).

loop(Name, Server) ->
    receive
        {half, Half, orig, Orig} ->
            io:format("Received ~p ~n", [Half]),
            Server ! {Name, Half, Orig}, loop(Name, Server)
    end.