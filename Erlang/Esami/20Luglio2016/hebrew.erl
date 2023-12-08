-module(hebrew).
-export([start/3]).


start(Label, K, Master) ->
    receive
        {next, Next} ->  loop(Label, K, Next, Master);
        Any -> io:format("ERROR ~p~n", [Any])
    end.


loop(Label, K, Next, Master) ->
            receive
                {newNext, NewNext} -> 
                    case NewNext == self() of
                        true -> 
                            Master ! {last_survivor, Label};

                        _ -> loop(Label, K, NewNext, Master)
                    end;
                {prev, Prev, mex, Mex, step, K} -> 
                    Prev ! {newNext, Next},
                    Next ! {prev, Prev, mex, Mex, step, 1};
                {prev, _, mex, Mex, step, Sk} ->
                    Next ! {prev, self(), mex, Mex, step, Sk+1},
                    loop(Label, K, Next, Master)
            end.

    
   