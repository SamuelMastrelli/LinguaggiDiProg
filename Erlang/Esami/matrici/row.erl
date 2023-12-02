-module(row).
-export([loop/2]).

loop(Row, Number) ->
    receive
        {send, B} -> send(Number, Row, B)      
    end.

send(Number, Row, [Last|[]])->
    Last ! {row, Number, Row};
send(Number, Row, [H|T]) ->
    H ! {row, Number, Row}, send(Number, Row, T).