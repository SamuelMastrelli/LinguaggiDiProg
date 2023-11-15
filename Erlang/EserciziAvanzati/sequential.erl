-module(sequential).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(L) -> 
    [(X * X) || X <- L, is_integer(X)].

intersect(L1, L2) -> 
    [X || X <- L1, lists:member(X, L1), lists:member(X, L2)].

symmetric_difference(L1, L2) -> 
    L3 = lists:append(L1, L2),
    [X || X <- L3,  not (lists:member(X, L1) and lists:member(X, L2))].