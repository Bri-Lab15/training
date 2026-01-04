require_relative 'piece'

# KING
class King < Piece
  # Unicode symbol for the king
  def symbol
    color == :white ? "♔" : "♚"
  end

  # King can move one square in any direction
  def moves
    x, y = position
    [ -1, 0, 1 ].product([ -1, 0, 1 ])
              .reject { |dx, dy| dx == 0 && dy == 0 }
              .map { |dx, dy| [ x + dx, y + dy ] }
  end
end

# QUEEN
class Queen < Piece
  def symbol
    color == :white ? "♕" : "♛"
  end

  # Queen moves like rook + bishop
  def moves
    straight + diagonal
  end
end

# ROOK
class Rook < Piece
  def symbol
    color == :white ? "♖" : "♜"
  end

  def moves
    straight
  end
end

# BISHOP
class Bishop < Piece
  def symbol
    color == :white ? "♗" : "♝"
  end

  def moves
    diagonal
  end
end

# KNIGHT
class Knight < Piece
  def symbol
    color == :white ? "♘" : "♞"
  end

  # Knight has special L-shaped movement
  def moves
    [ [ 1, 2 ], [ 2, 1 ], [ -1, 2 ], [ -2, 1 ],
     [ 1, -2 ], [ 2, -1 ], [ -1, -2 ], [ -2, -1 ] ]
      .map { |dx, dy| [ position[0] + dx, position[1] + dy ] }
  end
end

# PAWN (very simplified)
class Pawn < Piece
  def symbol
    color == :white ? "♙" : "♟"
  end

  # Pawns only move forward one square (no captures or first-move logic here)
  def moves
    x, y = position
    direction = color == :white ? -1 : 1
    [ [ x + direction, y ] ]
  end
end

# Helper movement methods shared by rook, bishop, and queen
class Piece
  # Vertical and horizontal movement
  def straight
    x, y = position
    (1..7).flat_map do |i|
      [ [ x+i, y ], [ x-i, y ], [ x, y+i ], [ x, y-i ] ]
    end
  end

  # Diagonal movement
  def diagonal
    x, y = position
    (1..7).flat_map do |i|
      [ [ x+i, y+i ], [ x-i, y-i ], [ x+i, y-i ], [ x-i, y+i ] ]
    end
  end
end
