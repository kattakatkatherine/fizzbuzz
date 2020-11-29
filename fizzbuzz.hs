divs x y = mod x y == 0

fizz x = (if divs x 3 then "Fizz" else [])
      ++ (if divs x 5 then "Buzz" else [])

buzz x = if length (fizz x) > 0
         then fizz x
         else show x
fizzbuzz x = map buzz x
