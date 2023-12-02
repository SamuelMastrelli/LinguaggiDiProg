-module(column).
-export([loop/3]).

loop(Column, RowNumber, Parent) ->
    receive
        {row, ColNumber, Row} -> N = result(Row, Column), 
                      Parent ! {row, RowNumber, col, ColNumber, N}, loop(Column, RowNumber, Parent)
    end.


result(R, C) ->
    result(R, C, 0).

result([], [], Res) -> Res;
result([R|Rs], [C|Cs], Res) ->
    Partial = R * C,
    result(Rs, Cs, Res + Partial).