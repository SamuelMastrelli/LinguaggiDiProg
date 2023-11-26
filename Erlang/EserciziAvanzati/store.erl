-module(store).
-export([start_store/0, start/0, store/2, lookup/1, stop/0]).

start() -> 
    register(storage, spawn(fun() -> loop() end)).
    

start_store() -> ping(nodes()), start(), start_on_others(nodes()).

start_on_others([]) -> io:format("All processes initialized.~n");
start_on_others([Node|Nodes]) ->
    io:format("~p nodes ~n", [[Node|Nodes]]),
    rpc:call(Node, store, start, []),
    start_on_others(Nodes).


store(Key, Value) -> rpc_node({store, Key, Value}, nodes()).
lookup(Key) -> rpc({lookup, Key}).
stop() -> rpc_node(stop, nodes()).


rpc_node(Q, [])  ->  
    storage ! {self(), Q},
    loop_reply(node());
rpc_node(Q, [Node|Nodes]) -> 
    {storage, Node} ! {self(), Q},
    loop_reply(Node),
    rpc_node(Q, Nodes).
    
rpc(Q) ->
    storage ! {self(), Q},
    loop_reply(node()).

loop_reply(Node)->
    receive
        {kvs, Reply} -> io:format("~p in ~p~n", [Reply, Node]);
        Any -> io:format("ERROR: ~p~n", [Any])
    end.

loop() ->
    receive
        {From, {store, Key, Value}} -> put(Key, {ok, Value}), From ! {kvs, stored}, loop();
        {From, {lookup, Key}} -> From ! {kvs, get(Key)}, loop();
        {From, stop} -> unregister(storage), From ! {kvs, "Stopped"} 
    end.

ping([]) -> net_adm:ping('sam1@sam-Intel'), net_adm:ping('sam2@sam-Intel');
ping(_) -> io:format("All nodes linked~n").