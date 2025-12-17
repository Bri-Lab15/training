# Node class
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

# LinkedList class
class LinkedList
  def initialize
    @head = nil
  end

  # Adds a new node containing value to the end of the list
  def append(value)
    new_node = Node.new(value)

    if @head.nil?
      @head = new_node
      return
    end

    tail.next_node = new_node
  end

  # Adds a new node containing value to the start of the list
  def prepend(value)
    new_node = Node.new(value, @head)
    @head = new_node
  end

  # Returns the total number of nodes in the list
  def size
    count = 0
    current = @head

    while current
      count += 1
      current = current.next_node
    end

    count
  end

  # Returns the first node in the list
  def head
    @head
  end

  # Returns the last node in the list
  def tail
    return nil if @head.nil?

    current = @head
    current = current.next_node while current.next_node
    current
  end

  # Returns the node at the given index
  def at(index)
    current = @head
    current_index = 0

    while current
      return current if current_index == index
      current = current.next_node
      current_index += 1
    end

    nil
  end

  # Removes the last element from the list
  def pop
    return nil if @head.nil?
    return @head = nil if @head.next_node.nil?

    current = @head
    current = current.next_node while current.next_node.next_node
    current.next_node = nil
  end

  # Returns true if the value is in the list
  def contains?(value)
    current = @head

    while current
      return true if current.value == value
      current = current.next_node
    end

    false
  end

  # Returns the index of the node containing value, or nil
  def find(value)
    current = @head
    index = 0

    while current
      return index if current.value == value
      current = current.next_node
      index += 1
    end

    nil
  end

  # Represents the LinkedList as a string
  def to_s
    current = @head
    result = ""

    while current
      result += "( #{current.value} ) -> "
      current = current.next_node
    end

    result + "nil"
  end

  # Extra credit: inserts a node at a given index
  def insert_at(value, index)
    return prepend(value) if index == 0

    previous = at(index - 1)
    return nil if previous.nil?

    new_node = Node.new(value, previous.next_node)
    previous.next_node = new_node
  end

  # Extra credit: removes a node at a given index
  def remove_at(index)
    return nil if @head.nil?
    return @head = @head.next_node if index == 0

    previous = at(index - 1)
    return nil if previous.nil? || previous.next_node.nil?

    previous.next_node = previous.next_node.next_node
  end
end

# ======================
# Test the Linked List
# ======================

list = LinkedList.new

list.append('dog')
list.append('cat')
list.append('parrot')
list.append('hamster')
list.append('snake')
list.append('turtle')

puts list
