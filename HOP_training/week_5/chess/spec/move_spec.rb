require_relative 'spec_helper'

RSpec.describe Move do
  let(:board) { Board.new }

  describe ".valid?" do
    it "allows a valid pawn move" do
      from = [ 6, 0 ] # a2
      to   = [ 5, 0 ] # a3

      expect(Move.valid?(board, from, to, :white)).to be true
    end

    it "prevents moving opponent's piece" do
      from = [ 1, 0 ] # black pawn
      to   = [ 2, 0 ]

      expect(Move.valid?(board, from, to, :white)).to be false
    end

    it "prevents moving off the board" do
      from = [ 7, 1 ]
      to   = [ 9, 2 ]

      expect(Move.valid?(board, from, to, :white)).to be false
    end
  end

  describe ".check?" do
    it "detects check" do
      # Clear the board so the test is simple
      board.grid = Array.new(8) { Array.new(8) }

      white_king = King.new(:white, [ 7, 4 ])
      black_rook = Rook.new(:black, [ 7, 0 ])

      board.grid[7][4] = white_king
      board.grid[7][0] = black_rook

      expect(Move.check?(board, :white)).to be true
    end
  end
end
