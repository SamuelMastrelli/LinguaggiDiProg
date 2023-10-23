
open SocialNet;;

let dfs v s =
    let rec dfs s v vs = function
        [] -> vs 
      | ad::ads -> if (SocialNet.is_in_list ad vs) then 
                        dfs s v vs ads 
                  else  
                    dfs s v (dfs s ad (ad::vs) (SocialNet.followed ad s)) ads  

    in 
        if (SocialNet.is_empty s) then raise SocialNet.SCempty
        else if not (SocialNet.found v s) then raise SocialNet.NodeNotInSC
        else dfs s v [v] (SocialNet.followed v s)

let visita s =
    let ns =
    match s with
    | SocialNet.SN (nodes, _) -> nodes in 
    let rec vis visited = function 
        [] -> visited
      | n::nv -> if SocialNet.is_in_list n visited  then 
                    vis visited nv 
                 else
                    vis ((dfs n s) @ visited) nv 
    in vis [] ns ;;


