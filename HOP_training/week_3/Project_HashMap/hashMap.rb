# =========================
# HashMap Implementation
# =========================

class HashMap
  DEFAULT_LOAD_FACTOR = 0.75
  DEFAULT_CAPACITY = 16

  def initialize(load_factor = DEFAULT_LOAD_FACTOR, capacity = DEFAULT_CAPACITY)
    @load_factor = load_factor
    @capacity = capacity
    @buckets = Array.new(@capacity) { [] } # separate chaining
    @size = 0
  end

  # --------------------
  # Hash function
  # --------------------
  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char do |char|
      hash_code = prime_number * hash_code + char.ord
    end

    hash_code
  end

  def index_for(key)
    hash(key) % @capacity
  end

  # --------------------
  # Core methods
  # --------------------
  def set(key, value)
    index = index_for(key)
    bucket = @buckets[index]

    bucket.each do |pair|
      if pair[0] == key
        pair[1] = value # overwrite existing value
        return
      end
    end

    # insert new key-value pair
    bucket << [ key, value ]
    @size += 1

    resize if load_exceeded?
  end

  def get(key)
    index = index_for(key)
    bucket = @buckets[index]

    bucket.each do |pair|
      return pair[1] if pair[0] == key
    end

    nil
  end

  def has?(key)
    index = index_for(key)
    @buckets[index].any? { |pair| pair[0] == key }
  end

  def remove(key)
    index = index_for(key)
    bucket = @buckets[index]

    bucket.each_with_index do |pair, i|
      if pair[0] == key
        bucket.delete_at(i)
        @size -= 1
        return pair[1]
      end
    end

    nil
  end

  # --------------------
  # Utility methods
  # --------------------
  def length
    @size
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    result = []
    @buckets.each do |bucket|
      bucket.each { |pair| result << pair[0] }
    end
    result
  end

  def values
    result = []
    @buckets.each do |bucket|
      bucket.each { |pair| result << pair[1] }
    end
    result
  end

  def entries
    result = []
    @buckets.each do |bucket|
      bucket.each { |pair| result << pair }
    end
    result
  end

  # --------------------
  # Resizing logic
  # --------------------
  def load_exceeded?
    (@size.to_f / @capacity) > @load_factor
  end

  def resize
    old_buckets = @buckets
    @capacity *= 2
    @buckets = Array.new(@capacity) { [] }
    @size = 0

    old_buckets.each do |bucket|
      bucket.each do |key, value|
        set(key, value)
      end
    end
  end
end

# =========================
# HashSet (Extra Credit)
# =========================

class HashSet
  def initialize
    @map = HashMap.new
  end

  def add(key)
    @map.set(key, true)
  end

  def has?(key)
    @map.has?(key)
  end

  def remove(key)
    @map.remove(key)
  end

  def length
    @map.length
  end

  def clear
    @map.clear
  end

  def keys
    @map.keys
  end
end

# =========================
# Test Script
# =========================

test = HashMap.new

test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')

puts "Length: #{test.length}"          # => 12
puts "Apple: #{test.get('apple')}"     # => red

# overwrite values
test.set('apple', 'green')
test.set('dog', 'black')

puts "Updated apple: #{test.get('apple')}"
puts "Updated dog: #{test.get('dog')}"
puts "Length after overwrite: #{test.length}" # => still 12

# trigger resize
test.set('moon', 'silver')

puts "Length after resize: #{test.length}" # => 13
puts "Has moon?: #{test.has?('moon')}"

puts "Removed moon value: #{test.remove('moon')}"
puts "Has moon after removal?: #{test.has?('moon')}"

p test.keys
p test.values
p test.entries

test.clear
puts "Length after clear: #{test.length}" # => 0
