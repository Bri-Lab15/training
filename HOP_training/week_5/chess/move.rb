# Handles checking whether moves are legal
class Move
  # Check if a move is allowed
  def self.valid?(board, from, to, color)
    piece = board.get(from)

    # Must move your own piece
    return false if piece.nil?
    return false if piece.color != color

    # Target square must be on the board
    return false unless board.in_bounds?(to)

    target = board.get(to)

    # Can't capture your own piece
    return false if target && target.color == color

    # Check if the piece is allowed to move that way
    piece.moves.include?(to)
  end

  # Check if the current player is in check
  def self.check?(board, color)
    king = board.king(color)

    board.grid.flatten.compact.any? do |piece|
      piece.color != color && piece.moves.include?(king.position)
    end
  end
end
