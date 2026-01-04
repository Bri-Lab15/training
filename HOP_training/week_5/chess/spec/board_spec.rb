require_relative 'spec_helper'

RSpec.describe Board do
  subject(:board) { Board.new }

  describe "#setup" do
    it "places a white king on the board" do
      king = board.grid.flatten.find do |piece|
        piece.is_a?(King) && piece.color == :white
      end

      expect(king).not_to be_nil
    end

    it "places pawns on the second row" do
      expect(board.grid[6].all? { |p| p.is_a?(Pawn) }).to be true
    end
  end
end
