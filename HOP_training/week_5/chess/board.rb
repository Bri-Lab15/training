require_relative 'pieces'

# Represents the chess board and holds all the pieces
class Board
  attr_accessor :grid

  def initialize
    # 8x8 grid, each cell holds a piece or nil
    @grid = Array.new(8) { Array.new(8) }
    setup
  end

  # Set up the starting positions of all pieces
  def setup
    back_row = [ Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook ]

    8.times do |i|
      grid[0][i] = back_row[i].new(:black, [ 0, i ])
      grid[1][i] = Pawn.new(:black, [ 1, i ])
      grid[6][i] = Pawn.new(:white, [ 6, i ])
      grid[7][i] = back_row[i].new(:white, [ 7, i  ])
    end
  end

  # Move a piece from one square to another
  def move(from, to)
    piece = get(from)
    grid[to[0]][to[1]] = piece
    grid[from[0]][from[1]] = nil
    piece.position = to
  end

  # Get the piece at a given position
  def get(pos)
    grid[pos[0]][pos[1]]
  end

  # Make sure the position is on the board
  def in_bounds?(pos)
    pos.all? { |n| n.between?(0, 7) }
  end

  # Find the king of a given color
  def king(color)
    grid.flatten.find { |p| p.is_a?(King) && p.color == color }
  end

  # Print the board to the terminal
  def render
    puts "\n  a b c d e f g h"
    grid.each_with_index do |row, i|
      print (8 - i).to_s + " "
      row.each { |p| print (p ? p.symbol : ".") + " " }
      puts (8 - i)
    end
    puts "  a b c d e f g h\n"
  end
end
