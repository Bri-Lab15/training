# Base class for all chess pieces
# Other piece classes inherit from this

class Piece
  attr_accessor :color, :position

  def initialize(color, position)
    @color = color        # :white or :black
    @position = position # [row, col]
  end
end
