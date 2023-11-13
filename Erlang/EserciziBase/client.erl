-module(client).
-export([client_test/0]).




client_test() -> 
    echo:start(),
    link(whereis(server)),
    spawn(fun() -> timer:sleep(4000), echo:stop() end),
    loop(0).

loop(N) -> 
    echo:print(N),
    timer:sleep(500),
    loop(N+1).
