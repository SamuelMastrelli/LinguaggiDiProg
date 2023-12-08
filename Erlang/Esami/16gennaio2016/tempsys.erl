-module(tempsys).
-export([startsys/0, convert/5]).


startsys()  -> 
    any_To_C(), c_To_Any().

convert(from, From, to, To, N) -> any_to_c ! {from, From, to, To, N}.


c_To_Any() -> register(c_to_any, spawn(fun() -> loop_to_any() end)).

any_To_C() -> register(any_to_c, spawn(fun() -> loop_to_c() end)).

loop_to_c() ->
    receive
        {from, 'Re', to, Target, N} -> c_to_any ! {from, (N * 5/4), to,  Target}, loop_to_c();
        {from, 'Ro', to, Target, N} -> c_to_any ! {from, ((N - 7.5) * 40/21), to,  Target}, loop_to_c();
        {from, 'N', to, Target, N} -> c_to_any ! {from, (N * 100/33), to,  Target}, loop_to_c();
        {from, 'De', to, Target, N} -> c_to_any ! {from, (100 - (N * 2/3)), to,  Target};
        {from, 'R', to, Target, N} -> c_to_any ! {from, ((N * 5/9) - 273.15), to,  Target}, loop_to_c();
        {from, 'K', to, Target, N} -> c_to_any ! {from, (N - 273.15), to,  Target}, loop_to_c();
        {from, 'F', to, Target, N} -> c_to_any ! {from, ((N - 32) * 5/9), to,  Target}, loop_to_c();
        Any -> io:format("ERROR ~p~n", [Any])
    end.

loop_to_any()->
    receive
        {from, N, to, 'Re'} -> io:format("~p C are equivalent to ~p Re ~n", [N, (N * 4/5)]), loop_to_any();
        {from, N, to, 'Ro'} -> io:format("~p C are equivalent to ~p Ro ~n", [N, ((N * 21/40) + 7.5)]), loop_to_any();
        {from, N, to, 'N'} -> io:format("~p C are equivalent to ~p N ~n", [N, (N * 33/100)]), loop_to_any();
        {from, N, to, 'De'} -> io:format("~p C are equivalent to ~p De ~n", [N, ((100 - N) * 3/2)]), loop_to_any();
        {from, N, to, 'R'} -> io:format("~p C are equivalent to ~p Ra ~n", [N, ((N + 273.15) * 9/5)]), loop_to_any();
        {from, N, to, 'K'} -> io:format("~p C are equivalent to ~p Re ~n", [N, (N + 273.15)]), loop_to_any();
        {from, N, to, 'F'} -> io:format("~p C are equivalent to ~p Re ~n", [N, ((N * 9/5) + 32)]), loop_to_any();
        Any -> io:format("ERROR ~p~n", [Any])
    end.