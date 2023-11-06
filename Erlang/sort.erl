-module(sort).
-export([qsort/2]).
qsort(_, []) -> [];
qsort(P, [Pivot|TL]) ->
qsort(P, [X||X<-TL, P(X,Pivot)]) ++ [Pivot] ++ qsort(P, [X||X<-TL, not P(X,Pivot)]).