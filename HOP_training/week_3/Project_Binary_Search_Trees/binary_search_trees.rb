# =========================
# Node class
# =========================
# Each node stores a value and has left and right children.
# Including Comparable allows comparison based on the node's data.
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  # Comparison based on the data value
  def <=>(other)
    data <=> other.data
  end
end

# =========================
# Tree class
# =========================
class Tree
  attr_accessor :root

  # Initialize tree from an array
  def initialize(array)
    @root = build_tree(array)
  end

  # Build a balanced BST from a sorted unique array
  def build_tree(array)
    array = array.uniq.sort  # Remove duplicates and sort
    return nil if array.empty?
    mid = array.length / 2
    root = Node.new(array[mid])  # Middle element becomes root
    root.left = build_tree(array[0...mid])      # Recursively build left subtree
    root.right = build_tree(array[mid+1..])     # Recursively build right subtree
    root
  end

  # Pretty print the tree visually
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  # Insert a value into the tree
  def insert(value, node = @root)
    return Node.new(value) if node.nil?  # Insert at leaf
    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value, node.right)
    end
    node
  end

  # Delete a value from the tree
  def delete(value, node = @root)
    return nil if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      # Node with only one child or no child
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # Node with two children: find inorder successor
      min_larger_node = find_min(node.right)
      node.data = min_larger_node.data
      node.right = delete(min_larger_node.data, node.right)
    end
    node
  end

  # Find the node with minimum value in a subtree
  def find_min(node)
    node.left ? find_min(node.left) : node
  end

  # Find a node with a specific value
  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value
    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  # Level-order (breadth-first) traversal
  def level_order(node = @root, &block)
    return [] if node.nil?
    queue = [ node ]  # Queue for BFS
    result = []

    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : result << current.data
      queue << current.left if current.left
      queue << current.right if current.right
    end
    block_given? ? nil : result
  end

  # Inorder traversal (left, root, right)
  def inorder(node = @root, &block)
    return [] if node.nil?
    result = inorder(node.left)
    block_given? ? yield(node) : result << node.data
    result += inorder(node.right)
    result
  end

  # Preorder traversal (root, left, right)
  def preorder(node = @root, &block)
    return [] if node.nil?
    result = block_given? ? yield(node) : [ node.data ]
    result += preorder(node.left, &block)
    result += preorder(node.right, &block)
    result
  end

  # Postorder traversal (left, right, root)
  def postorder(node = @root, &block)
    return [] if node.nil?
    result = postorder(node.left, &block)
    result += postorder(node.right, &block)
    block_given? ? yield(node) : (result << node.data)
    result
  end

  # Height of a node (longest path to a leaf)
  def height(node)
    return -1 if node.nil?  # Base case
    [ height(node.left), height(node.right) ].max + 1
  end

  # Depth of a node (edges from root to node)
  def depth(value, node = @root, current_depth = 0)
    return nil if node.nil?
    return current_depth if node.data == value
    if value < node.data
      depth(value, node.left, current_depth + 1)
    else
      depth(value, node.right, current_depth + 1)
    end
  end

  # Check if tree is balanced
  def balanced?(node = @root)
    return true if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)
    (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  # Rebalance the tree
  def rebalance
    values = inorder  # Get sorted values
    @root = build_tree(values)
  end
end

# =========================
# Driver Script
# =========================
tree = Tree.new(Array.new(15) { rand(1..100) })  # Create tree with 15 random numbers

puts "Initial Tree:"
tree.pretty_print
puts "\nIs tree balanced? #{tree.balanced?}"
puts "Level-order: #{tree.level_order}"
puts "Pre-order: #{tree.preorder}"
puts "In-order: #{tree.inorder}"
puts "Post-order: #{tree.postorder}"

# Unbalance the tree by inserting larger numbers
[ 101, 102, 103, 104 ].each { |v| tree.insert(v) }

puts "\nAfter inserting values > 100 (unbalanced):"
tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"

# Rebalance the tree
tree.rebalance

puts "\nAfter rebalancing:"
tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"
puts "Level-order: #{tree.level_order}"
puts "Pre-order: #{tree.preorder}"
puts "In-order: #{tree.inorder}"
puts "Post-order: #{tree.postorder}"
