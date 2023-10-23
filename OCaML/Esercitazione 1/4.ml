open Str;;

let file = open_in "File.txt";;

let count s1 s2 =
    let ls = split (regexp "[\\p{Punct}]") s2 in 
    let rec c acc ls =
      match ls with 
          [] -> acc 
        | h::tl -> if (String.equal h s1) then c (acc+1) tl else c acc tl 
    in c 0 ls;;

let countAll file =
  let st = really_input_string file (in_channel_length file) and 
      ls = 
      