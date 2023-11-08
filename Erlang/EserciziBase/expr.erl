-module(expr).
-export([eval/1, fromstring/1]).


fromstring(S) ->
    fromstring(S, [], []).

fromstring([], [Expr], _) -> Expr; 
fromstring([$(|T], Expr, Ops) -> fromstring(T, Expr, Ops);
fromstring([$+|T], Expr, Ops) -> fromstring(T, Expr, [$+|Ops]);
fromstring([$-|T], Expr, Ops) -> fromstring(T, Expr, [$-|Ops]);
fromstring([$*|T], Expr, Ops) -> fromstring(T, Expr, [$*|Ops]);
fromstring([$/|T], Expr, Ops) -> fromstring(T, Expr, [$/|Ops]);
fromstring([$~|T], Expr, Ops) -> fromstring(T, Expr, [$~|Ops]);
fromstring([$)|T], Expr, Ops) -> 
    extract(Expr, Ops, T);
fromstring([N|T], Expr, Ops) -> fromstring(T, [({num, N})|Expr], Ops).

extract([], _, _) -> erlang:error("Invalid expression");
extract(_, [], _) -> erlang:error("Invalid expression");
extract([E|T], [$~|O], C) -> fromstring(C, [{minus, E}|T], O);
extract([E1|[E2|T]], [$+|O], C) -> fromstring(C, [{plus, E2, E1}|T], O);
extract([E1|[E2|T]], [$-|O], C) -> fromstring(C, [{minus, E2, E1}|T], O);
extract([E1|[E2|T]], [$*|O], C) -> fromstring(C, [{times, E2, E1}|T], O);
extract([E1|[E2|T]], [$/|O], C) -> fromstring(C, [{division, E2, E1}|T], O).

eval({num, N}) -> firstOfTuple(string:to_integer([N]));
eval({plus, Expr}) -> eval(Expr);
eval({minus, Expr}) ->  - eval(Expr);
eval({_, _}) -> erlang:error("Invalid expression");
eval({plus, E1, E2}) -> eval(E1) + eval(E2);
eval({minus, E1, E2}) -> eval(E1) - eval(E2);
eval({times, E1, E2}) -> eval(E1) * eval(E2);
eval({division, E1, E2}) -> eval(E1) / eval(E2).

firstOfTuple({E, _}) -> E.
