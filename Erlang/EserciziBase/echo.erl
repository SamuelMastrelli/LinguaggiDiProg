-module(echo).
-export([start/0, print/1, stop/0]).

start() -> register(server, server:start_server()).

print(Term) -> server ! {print, Term}.

stop() -> exit(whereis(server), stopped).