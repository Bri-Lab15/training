def factorial(num)
  # write a recursive method for calculating the [factorial](https://simple.wikipedia.org/wiki/Factorial) of a number
  if num == 0
    1
  else
    num * factorial(num - 1)
  end
end
