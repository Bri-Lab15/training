# First, we're going to practice reading the Stack Trace
# Don't look at this method prior to running the test
# Type 'rspec' into the terminal to run Rspec
# Once this test fails, have a look at the Stack Trace
# Try to see if you can work your way from the last line, the bottom of the stack
# To the top, the first line, where the error occurred, and ONLY THEN fix the error

def decrement_smallest_value(nested_array)
  # Find smallest value
  smallest = nested_array.flatten.min
  # Find first occurrence and decrement it in-place
  nested_array.each_with_index do |sub, i|
    sub.each_with_index do |val, j|
      if val == smallest
        nested_array[i][j] = val - 1
        return nested_array
      end
    end
  end
  nested_array
end

# use the stack trace to debug the following method
# Don't look at this method prior to running the test
# Run rspec, let the test fail, and go through the stack trace again

def increment_greatest_value(nested_array)
  # Find greatest value
  greatest = nested_array.flatten.max
  # Find first occurrence and increment it in-place
  nested_array.each_with_index do |sub, i|
    sub.each_with_index do |val, j|
      if val == greatest
        nested_array[i][j] = val + 1
        return nested_array
      end
    end
  end
  nested_array
end

# This next exercise might look familiar
# Use p and puts in order to find what's wrong with our method

def isogram?(string)
  # remove non-letter characters, compare unique letters ignoring case
  cleaned = string.downcase.gsub(/[^a-z]/, '')
  cleaned.chars.uniq.length == cleaned.length
end

# Can you guess what's next?
# That's right! The final exercise from the lesson, which we'll debug with pry-byebug
# Try to avoid looking at the problem too much, let's rely on pry to fix it
# First, include require 'pry-byebug' at the top of this page
# Next insert plenty of breakpoints, and see if you can tell where things break
# Once you find the error, fix it and get the test to pass

def yell_greeting(string)
  name = string.upcase
  "WASSAP, #{name}!"
end
