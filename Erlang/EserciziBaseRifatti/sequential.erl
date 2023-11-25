-module(sequential).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

is_palindrome(S) -> 
    F = lists:filter(fun(X) -> not lists:member(X, [$., $,, $!, $?, 32]) end, S),
    L = string:lowercase(F),
    string:equal(lists:reverse(L), L).


is_an_anagram(_, []) -> false;
is_an_anagram(S, [S1|SL]) ->
    is_anagram(S, S1) or is_an_anagram(S, SL).

is_anagram(S, S1) ->
    string:equal(lists:sort(S), lists:sort(S1)).



factors(N) ->  
    Pr = primes(N),
    lists:filter((fun(X) -> N rem X == 0 end), Pr).

is_proper(N) -> 
    Div = lists:filter((fun(X) -> N rem X == 0 end), [1|numbers([], N-1)]),
    lists:sum(Div) == N.

primes(N) ->
    L = numbers([], (N-1)),
    crivello(L).

numbers(Acc, 2) -> [2|Acc];
numbers(Acc, N) -> numbers([N|Acc], N-1).

crivello([]) -> [];
crivello([H|TL]) -> [H|crivello(lists:filter(fun(X) -> X rem H /= 0 end, TL))].
