

# Add color support for nicer UI
class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
  def cyan; "\e[36m#{self}\e[0m" end
  def yellow; "\e[33m#{self}\e[0m" end
end

# ------------------------------
# Player Class
# ------------------------------
class Player
  attr_reader :name, :marker, :ai

  def initialize(name, marker, ai: false)
    @name = name
    @marker = marker
    @ai = ai
  end

  def ai?
    @ai
  end
end

# ------------------------------
# Board Class
# ------------------------------
class Board
  attr_reader :cells

  WIN_COMBINATIONS = [
    [ 0, 1, 2 ], [ 3, 4, 5 ], [ 6, 7, 8 ],       # rows
    [ 0, 3, 6 ], [ 1, 4, 7 ], [ 2, 5, 8 ],       # cols
    [ 0, 4, 8 ], [ 2, 4, 6 ]                 # diagonals
  ]

  def initialize
    @cells = Array.new(9, " ")
  end

  def display
    puts ""
    rows = [
      " #{color(@cells[0])} | #{color(@cells[1])} | #{color(@cells[2])} ",
      "---+---+---",
      " #{color(@cells[3])} | #{color(@cells[4])} | #{color(@cells[5])} ",
      "---+---+---",
      " #{color(@cells[6])} | #{color(@cells[7])} | #{color(@cells[8])} "
    ]
    puts rows
    puts ""
  end

  def color(value)
    case value
    when "X" then value.red
    when "O" then value.green
    else value.cyan
    end
  end

  def empty_positions
    @cells.each_index.select { |i| @cells[i] == " " }
  end

  def valid_move?(index)
    index.between?(0, 8) && @cells[index] == " "
  end

  def make_move(index, marker)
    @cells[index] = marker
  end

  def full?
    !@cells.include?(" ")
  end

  def winner
    WIN_COMBINATIONS.each do |combo|
      a, b, c = combo
      if @cells[a] != " " &&
         @cells[a] == @cells[b] &&
         @cells[b] == @cells[c]
        return @cells[a]
      end
    end
    nil
  end

  def terminal?
    winner || full?
  end
end

# ------------------------------
# Minimax AI
# ------------------------------
class AI
  def initialize(marker)
    @marker = marker
    @opponent = marker == "X" ? "O" : "X"
  end

  def best_move(board)
    minimax(board, @marker)[:index]
  end

  def minimax(board, player)
    # Terminal evaluation
    if board.winner == @marker
      return { score: 1 }
    elsif board.winner == @opponent
      return { score: -1 }
    elsif board.full?
      return { score: 0 }
    end

    moves = []

    board.empty_positions.each do |index|
      new_board = Board.new
      new_board.instance_variable_set(:@cells, board.cells.dup)
      new_board.make_move(index, player)

      result = minimax(new_board, player == @marker ? @opponent : @marker)
      moves << { index: index, score: result[:score] }
    end

    if player == @marker
      moves.max_by { |m| m[:score] }
    else
      moves.min_by { |m| m[:score] }
    end
  end
end

# ------------------------------
# Game Class
# ------------------------------
class Game
  def initialize
    puts "Play against Human or AI?"
    puts "1) Human"
    puts "2) AI (Unbeatable)"
    print "> "
    choice = gets.chomp

    if choice == "2"
      setup_human_vs_ai
    else
      setup_human_vs_human
    end

    @board = Board.new
    @current_player = @player1
  end

  def setup_human_vs_human
    print "Player 1 name: "
    p1 = gets.chomp
    print "Player 2 name: "
    p2 = gets.chomp

    @player1 = Player.new(p1, "X")
    @player2 = Player.new(p2, "O")
  end

  def setup_human_vs_ai
    print "Your name: "
    p1 = gets.chomp

    @player1 = Player.new(p1, "X")
    @player2 = Player.new("AI", "O", ai: true)

    @ai_engine = AI.new("O")
  end

  def play
    loop do
      @board.display
      puts "#{@current_player.name}'s turn (#{@current_player.marker}):"

      move = if @current_player.ai?
               sleep 0.5
               @ai_engine.best_move(@board)
      else
               request_move
      end

      @board.make_move(move, @current_player.marker)

      if @board.winner
        @board.display
        puts "🎉 #{colorize_player(@current_player)} WINS!"
        break
      elsif @board.full?
        @board.display
        puts "🤝 It's a draw!"
        break
      end

      switch_player
    end
  end

  def request_move
    loop do
      print "Choose a position (1–9): "
      input = gets.chomp
      index = input.to_i - 1

      return index if @board.valid_move?(index)

      puts "❌ Invalid move. Try again."
    end
  end

  def switch_player
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

  def colorize_player(player)
    player.marker == "X" ? player.name.red : player.name.green
  end
end

# ------------------------------
# Start Game
# ------------------------------
Game.new.play
