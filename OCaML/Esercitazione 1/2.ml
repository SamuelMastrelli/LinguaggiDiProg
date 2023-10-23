
type temp = (scale * float) and  scale = Celsius | Fahrenheit | Kelvin | Rankine | Desisle | Newton | Reamur | Romer;;

let anyToCelsius = function 
      (Celsius , n) -> (Celsius, n)
    | (Fahrenheit, n) -> (Celsius, (n -. 32.) *. (5. /. 9.))
    | (Kelvin, n) -> (Celsius, n -.273.15)
    | (Rankine, n) -> (Celsius, (n -. 491.67) *. (5. /. 9.))
    | (Desisle, n) -> (Celsius, 100. -. (n *. (5. /. 9.)))
    | (Newton, n) -> (Celsius, n *. (100. /. 33.))
    | (Reamur, n) -> (Celsius, n *. (5. /. 4.))
    | (Romer, n) -> (Celsius, (n -. 7.5) *. (40. /. 21.));;
   


     