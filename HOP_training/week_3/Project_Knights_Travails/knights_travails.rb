# =========================
# Knight's Travails
# =========================

# Class representing a node on the chessboard
# Each node stores its position and a reference to its parent node
# The parent reference is used to reconstruct the path once we reach the target
class KnightNode
  attr_accessor :position, :parent

  def initialize(position, parent = nil)
    @position = position  # Current position on the board [x, y]
    @parent = parent      # Previous node in the path
  end
end

# All possible knight moves relative to current position
KNIGHT_MOVES = [
  [ 2, 1 ], [ 1, 2 ], [ -1, 2 ], [ -2, 1 ],
  [ -2, -1 ], [ -1, -2 ], [ 1, -2 ], [ 2, -1 ]
]

# Check if a given position is inside the 8x8 chessboard
def valid_position?(pos)
  x, y = pos
  x.between?(0, 7) && y.between?(0, 7)
end

# Returns all valid knight moves from a given position
def possible_moves(pos)
  # Add each move to current position and filter out invalid positions
  KNIGHT_MOVES.map { |dx, dy| [ pos[0]+dx, pos[1]+dy ] }
              .select { |new_pos| valid_position?(new_pos) }
end

# BFS algorithm to find the shortest path for a knight
def knight_moves(start_pos, end_pos)
  start_node = KnightNode.new(start_pos) # Starting node
  queue = [ start_node ]                   # Queue for BFS
  visited = [ start_pos ]                  # Track visited positions to avoid cycles

  until queue.empty?
    current_node = queue.shift           # Dequeue the next node to process

    # If we reached the target, reconstruct and return the path
    return build_path(current_node) if current_node.position == end_pos

    # Explore all valid moves from the current position
    possible_moves(current_node.position).each do |next_pos|
      next if visited.include?(next_pos)          # Skip if already visited
      visited << next_pos                         # Mark as visited
      queue << KnightNode.new(next_pos, current_node)  # Enqueue with parent reference
    end
  end
end

# Reconstructs the path from the target node back to the start
def build_path(node)
  path = []
  current = node
  # Follow parent links back to start
  while current
    path.unshift(current.position)  # Insert at the beginning
    current = current.parent
  end
  # Output path information
  puts "You made it in #{path.length - 1} moves! Here's your path:"
  path.each { |pos| puts pos.inspect }
  path
end

# =========================
# Example runs
# =========================

# Knight moves from [0,0] to [1,2] (1 move)
knight_moves([ 0, 0 ], [ 1, 2 ])
puts "-"*30

# Knight moves from [0,0] to [3,3] (2 moves)
knight_moves([ 0, 0 ], [ 3, 3 ])
puts "-"*30

# Knight moves from [3,3] to [0,0] (2 moves)
knight_moves([ 3, 3 ], [ 0, 0 ])
puts "-"*30

# Knight moves from [0,0] to [7,7] (longer path)
knight_moves([ 0, 0 ], [ 7, 7 ])
