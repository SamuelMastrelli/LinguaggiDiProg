-module(hypercube).
-export([create/0, grays_label/0, hamilton/2]).

create() ->
    Labels = grays_label(),
    Pids = [{Gray, spawn(fun() -> init(Gray) end)} || Gray <- Labels],
    lists:foreach((fun(NP) -> set_neighbors(NP, Pids) end), Pids),
    register(main, spawn(fun() -> main(Pids) end)).

main(Pids) ->
    receive
        {msg, Msg, path, [First|Path]} ->
            {_, Pid} = hd(find(First, Pids)),
            Pid ! {msg, Msg, Path},
            main(Pids)
            
    end.


grays_label() ->
    [[0,0,0,0],
     [0,0,0,1],
     [0,0,1,1],
     [0,0,1,0],
     [0,1,1,0],
     [0,1,1,1],
     [0,1,0,1],
     [0,1,0,0],
     [1,1,0,0],
     [1,1,0,1],
     [1,1,1,1],
     [1,1,1,0],
     [1,0,1,0],
     [1,0,1,1],
     [1,0,0,1],
     [1,0,0,0]].

init(Node) ->
    receive
        {neigh, NodePids} ->
            io:format("The process labeled '~p' just started~n", [Node]),
            loop_main(Node, NodePids)
    end.

set_neighbors({Node, Pid}, NodePids) ->
    Neigh = lists:filter((fun({N, _}) -> lists:member(N, neighbors(Node)) end), NodePids),
    io:format("~p~n", [Neigh]),
    Pid ! {neigh, Neigh}.

neighbors([N1, N2, N3, N4]) ->
    [[N1, N2, N3, (N4+1) rem 2],
     [N1, N2, (N3+1) rem 2, N4],
     [N1, (N2+1) rem 2, N3, N4],
     [(N1+1) rem 2, N2, N3, N4]].


loop_main(Node, Nodes) ->
    receive
        {msg, _, []} -> io:format("no more nodes avalable~n");
        {msg, Msg, [Next|Pids]} ->
            io:format("~p", [Msg]),
            Found = find(Next, Nodes),
            case Found == []  of
                true -> io:format("No more nodes available~n");
                _ ->   {Label, First} = hd(Found),
                case lists:member({Label, First}, Nodes) of 
                    true -> First ! {msg, {src, Node, msg, Msg}, [Pids]}, loop_main(Node, Nodes);
                    _ -> io:format("Node unreachble ~p~n", [Label])
                end
            end
    end.

find(Next, Pids) ->
    lists:filter(fun({N, _}) -> N == Next end, Pids).

hamilton(Msg, Path) ->
    main ! {msg, Msg, path, Path}.
