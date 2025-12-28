require_relative "../game"

describe Board do
  let(:board) { Board.new }

  describe "#winner" do
    it "returns X when X wins a row" do
      board.instance_variable_set(:@cells,
        [ "X", "X", "X",
         " ", " ", " ",
         " ", " ", " " ]
      )
      expect(board.winner).to eq("X")
    end

    it "returns O when O wins a column" do
      board.instance_variable_set(:@cells,
        [ "O", " ", " ",
         "O", " ", " ",
         "O", " ", " "  ]
      )
      expect(board.winner).to eq("O")
    end

    it "returns X when X wins diagonally" do
      board.instance_variable_set(:@cells,
        [ "X", " ", " ",
         " ", "X", " ",
         " ", " ", "X" ]
      )
      expect(board.winner).to eq("X")
    end

    it "returns nil if there is no winner" do
      expect(board.winner).to be_nil
    end
  end

  describe "#full?" do
    it "returns true when the board is full" do
      board.instance_variable_set(:@cells, Array.new(9, "X"))
      expect(board.full?).to be true
    end

    it "returns false when the board has empty spaces" do
      expect(board.full?).to be false
    end
  end

  describe "#valid_move?" do
    it "returns true for an empty spot" do
      expect(board.valid_move?(0)).to be true
    end

    it "returns false for a taken spot" do
      board.make_move(0, "X")
      expect(board.valid_move?(0)).to be false
    end

    it "returns false for an invalid index" do
      expect(board.valid_move?(10)).to be false
    end
  end
end
