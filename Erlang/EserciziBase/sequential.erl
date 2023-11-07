-module(sequential).
-export([is_palindrome/1, is_anagram/2, factors/1, is_proper/1]).

is_palindrome(S) ->
    L =  lists:filter((fun(C) -> not lists:member(C, [$., $,, $?, 32]) end), S),
    Lower = string:lowercase(L),
    string:equal(lists:reverse(Lower), Lower).


is_anagram(S, L) ->
    Sorted = lists:sort(S),
    lists:foldl((fun(E, P) -> 
        SortedE = lists:sort(E),
        string:equal(Sorted, SortedE) or P end), false, L).

factors(N) when N < 3 -> [];
factors(N) -> 
    Pr = primes(N),
    lists:filter((fun(X) -> N rem X == 0 end), Pr).


is_proper(N) ->
    Div = lists:filter((fun(X) -> N rem X == 0 end), numbers([], N, 1)),
    somme(0, N, Div).

somme(N, N, _) -> true ;
somme(_, _, []) -> false ;
somme(Acc, N, [H|TL]) when Acc > N -> somme(0, N, [H|TL]) ;
somme(Acc, N , [H|TL]) -> somme((Acc+H), N, TL) .

primes(N) -> 
    Nu = numbers([], N, 2),
    crivello(lists:reverse(Nu)).
    

numbers(Acc, N, N) -> Acc;
numbers(Acc, N, I) -> numbers([I|Acc], N, (I+1)).


crivello([]) -> [];
crivello([H|TL]) -> [H|crivello(lists:filter((fun(X) -> X rem H /= 0 end), TL))].


