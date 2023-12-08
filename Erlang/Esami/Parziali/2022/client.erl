-module(client).
-export([start/0, is_palindrome/1, close/0]).

start() ->
    {_, Host} = inet:gethostname(),
    register(client, spawn_link(fun() -> 
        group_leader(whereis(user), self()), 
        Server = spawn_link(list_to_atom("server@"++Host), server, init, []),
        MM1 = spawn_link(list_to_atom("mm1@"++Host), mm, init, [mm1, Server]),
        MM2 = spawn_link(list_to_atom("mm2@"++Host), mm, init, [mm2, Server]),
        loop(MM1, MM2) end)).


is_palindrome(List) ->
    client ! {palindrome, List}.

close() -> 
    io:format("Closing...~n"),
    exit(closed).

loop(MM1, MM2) ->
    receive
        {palindrome, List} ->
            {F, S} = split(List),
            MM1 ! {half, F, orig, List},
            MM2 ! {half, lists:reverse(S), orig, List}, loop(MM1, MM2)
    end.

split(List) ->
    L = length(List),
    Half = trunc(L/2),
    Second = lists:sublist(List, Half+1, L-Half+1),
    case L rem 2 == 0 of
        true -> {lists:sublist(List, Half), Second};
        _ -> {lists:sublist(List, Half+1), Second}
    end.