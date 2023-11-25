-module(expr).
-export([from_string/1, eval/1]).


from_string(S) ->
    from_string(S, [], []).

from_string([], _, [Expr]) -> Expr;
from_string([$(|E], Op, Exp) -> from_string(E, Op, Exp);
from_string([$+|E], Op, Exp) -> from_string(E, [$+|Op], Exp);
from_string([$-|E], Op, Exp) -> from_string(E, [$-|Op], Exp);
from_string([$*|E], Op, Exp) -> from_string(E, [$*|Op], Exp);
from_string([$/|E], Op, Exp) -> from_string(E, [$/|Op], Exp);
from_string([$~|E], Op, Exp) -> from_string(E, [$~|Op], Exp);
from_string([$)|E], [$~|Op], [E1|Exp]) -> 
        from_string(E, Op, [{minus, E1}|Exp]);
from_string([$)|E], [O|Op], [E1|[E2|Exp]]) -> 
    from_string(E, Op, [to_exp(O, E1, E2)|Exp]);
from_string([N|E], Op, Exp) ->
    {Num, _} = string:to_integer([N]),
    from_string(E, Op, [{num, Num}|Exp]).



to_exp(Op, E1, E2) ->
    case Op of
        $+ -> {plus, E2, E1};
        $- -> {minus, E2, E1};
        $* -> {times, E2, E1};
        $/ -> {division, E2, E1}
    end.


eval({num, N}) -> N;
eval({minus, E1}) ->  - eval(E1);
eval({plus, E1, E2}) -> eval(E1) + eval(E2);
eval({minus, E1, E2}) -> eval(E1) - eval(E2);
eval({times, E1, E2}) -> eval(E1) * eval(E2);
eval({division, E1, E2}) -> eval(E1) / eval(E2).



