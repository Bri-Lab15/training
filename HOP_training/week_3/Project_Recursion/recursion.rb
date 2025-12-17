# =========================
# Fibonacci - Iterative
# =========================

def fibs(n)
  return [] if n <= 0
  return [ 0 ] if n == 1

  sequence = [ 0, 1 ]

  (n - 2).times do
    sequence << sequence[-1] + sequence[-2]
  end

  sequence
end

# =========================
# Fibonacci - Recursive
# =========================

def fibs_rec(n)
  puts 'This was printed recursively'

  return [] if n <= 0
  return [ 0 ] if n == 1
  return [ 0, 1 ] if n == 2

  prev = fibs_rec(n - 1)
  prev << prev[-1] + prev[-2]
end

# =========================
# Merge Sort (Recursive)
# =========================

def merge_sort(array)
  return array if array.length <= 1

  mid = array.length / 2
  left = merge_sort(array[0...mid])
  right = merge_sort(array[mid..-1])

  merge(left, right)
end

def merge(left, right)
  result = []

  until left.empty? || right.empty?
    if left.first <= right.first
      result << left.shift
    else
      result << right.shift
    end
  end

  result + left + right
end

# =========================
# Tests
# =========================

puts "Iterative Fibonacci:"
p fibs(8)
p fibs(1)
p fibs(0)

puts "\nRecursive Fibonacci:"
p fibs_rec(8)

puts "\nMerge Sort Tests:"
p merge_sort([])
p merge_sort([ 73 ])
p merge_sort([ 1, 2, 3, 4, 5 ])
p merge_sort([ 3, 2, 1, 13, 8, 5, 0, 1 ])
p merge_sort([ 105, 79, 100, 110 ])
