-module(client).
-export([start/0, is_palindrome/1, close/0]).


start() ->
    group_leader(whereis(user), self()),
    {ok, Hostname} = inet:gethostname(),
    Server = spawn_link(list_to_atom("server@" ++ Hostname), server, init, []),
    MM1 = spawn_link(list_to_atom("mm1@" ++ Hostname), mm, init, [mm1, Server]),
    MM2 = spawn_link(list_to_atom("mm2@" ++ Hostname), mm, init, [mm2, Server]),
    register(client, spawn_link(fun() -> loop(MM1, MM2) end)),
    io:format("Serve started on ~p~n", [Hostname]),
    io:format("Nodes :- ~p~n", [nodes()]).


is_palindrome(Orig) -> client ! {pali, Orig}.

loop(MM1, MM2) ->
    receive
        {pali, Orig} -> 
            {F,S} = split(Orig),
            MM1 ! {F, Orig}, MM2 ! {S, Orig}, loop(MM1, MM2)
    end.

split(Orig) ->
    L = length(Orig),
    L2 = trunc(L/2),
    case L rem 2 == 0 of
        true -> {lists:sublist(Orig, L2), lists:reverse(lists:sublist(Orig, L2 + 1, L))};
        _ -> {lists:sublist(Orig, L2 + 1), lists:reverse(lists:sublist(Orig, L2 + 1, L))}
    end.

close() -> exit(whereis(client)).