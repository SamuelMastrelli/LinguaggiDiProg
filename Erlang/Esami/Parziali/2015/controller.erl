-module(controller).
-export([start/1]).

start(N) when N < 3 -> io:format("No number can be classified prime.");
start(N) ->
    group_leader(whereis(user), self()),
    register(controller, self()), 
    {ok, Host} = inet:gethostname(),
    Client = spawn_link(list_to_atom("client@" ++ Host), client, init, [self()]),
    init(N, Client).
    

init(N, Client)->
    Pid = spawn_link(sieve, init, [2]),
    {Pids, Last}  = create_ring(N),
    Sieves = [Pid|Pids],
    Cop = lists:zip(Sieves, tl(Sieves) ++ [hd(Sieves)]),
    {First, Next} = hd(Cop),
    First ! {init, Next, self(), first},
    initiates(tl(Cop), First),
    loop(First, Client, Last).

loop(First, Client, Last) ->
    receive
        {res, Res} -> 
            Client ! {result, Res}, loop(First, Client, Last);
        {new, N} -> 
            io:format("You asked for: ~p~n", [N]),
            case Last =< trunc(math:sqrt(N))  of
                true -> Client ! {result, tooLarge}, loop(First, Client, Last);
                _ ->    First ! {new, N}, loop(First, Client, Last)
            end;
        {quit} -> exit(self())
    end.

create_ring(N) ->
    Numbers = [X || X <- lists:seq(2, N), 
    length([Y || Y <- lists:seq(2, trunc(math:sqrt(X))), X rem Y == 0]) == 0],
    L = [spawn_link(sieve, init, [X])|| X <- Numbers],
    {L, lists:last(Numbers)}.

initiates([{Pid, Next}|[]], First) ->
    Pid ! {init, Next, First, notFirst};
initiates([{Pid, Next}|Pids], First) ->
    Pid ! {init, Next, First, notFirst}, initiates(Pids, First).