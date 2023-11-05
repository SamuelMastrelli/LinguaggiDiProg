-module(mfr).
-export([map/2, filter/2, reduce/2]).

map(_, []) -> [];
map(F, [H|TL]) -> [F(H)|map(F, TL)].

filter(_, []) -> [];
filter(P, [H|TL]) -> filter(P(H), P, H TL).

filter(true, P, H, TL) -> [H|filter(P, TL)];
filter(false P, _, TL) -> filter(P, TL).

reduce(F, [H|TL]) -> reduce(F, H TL).

reduce(_, Q, []) -> Q;
reduce(F, Q, [H|TL]) -> reduce(F, (F(Q, H)), TL).