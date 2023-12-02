-module(matrix).
-export([mproduct/2]).

mproduct(A, B) ->
    R = processRows(A),
    C = processCol(B),
    Void = empty(length(A), length(B)),
    calc(R, C, Void, (length(A) * length(B))).

processRows(M) ->
    [spawn_link(row, loop, [Row, Number]) || {Number, Row} <- lists:enumerate(1, M) ].


processCol(M) ->
    Parent = self(),
    [spawn_link(column, loop, [Col, Number, Parent])|| {Number, Col} <- lists:enumerate(1, M)].

empty(C, R) ->
    [zeroes(R) || _ <- lists:seq(1, C)].

zeroes(N) ->
    [0 || _ <- lists:seq(1, N)].

calc([], _, P, N) -> 
        loop(P, N);
calc([R|Rs], C, P, N) ->
    R ! {send, C},
    calc(Rs, C, P, N).

insert(P, Rn, Cn, N) ->
    Col = lists:nth(Cn, P),
    Updated = update(Col, Rn, N),
    update(P, Cn, Updated).


update(Col, Rn, N) ->
    update(Col, Rn, N, 1, []).

update([], _, _, _, Up ) -> lists:reverse(Up);
update([El|T], Rn, N, Pos, Up) ->
    case Rn == Pos of
        true -> update(T, Rn, N, Pos+1, [N|Up]);
        _ -> update(T, Rn, N, Pos+1, [El|Up])
    end.
loop(P, 0) -> P;
loop(P, Max) ->
   receive
        {row, Rn, col, Cn, N} ->
            io:format("~p, ~p, ~p~n", [Rn, Cn, N]),
            NewP = insert(P, Rn, Cn, N), loop(NewP, Max-1)
    end.
