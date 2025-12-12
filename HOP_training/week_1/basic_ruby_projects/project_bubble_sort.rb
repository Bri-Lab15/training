# bubble_sort method: sorts an array in ascending order using bubble sort.
def bubble_sort(array)
  n = array.length
  # If the array has 0 or 1 element, it's already “sorted”
  return array if n <= 1

  loop do
    swapped = false  # A flag to tell if any swaps happened in this pass

    # Walk through array from first to second-last element
    (n - 1).times do |i|
      # If the current element is greater than the next, swap them
      if array[i] > array[i + 1]
        array[i], array[i + 1] = array[i + 1], array[i]
        swapped = true
      end
    end

    # If no swaps occurred on this pass, the array is sorted — stop looping
    break unless swapped
  end

  array  # Return the sorted array
end

# === Example usage ===
p bubble_sort([ 4, 3, 78, 2, 0, 2 ])
# => [0, 2, 2, 3, 4, 78]
