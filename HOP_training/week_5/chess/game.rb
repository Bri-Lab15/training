require_relative 'board'
require_relative 'move'
require_relative 'save_load'

# Controls the main game loop
class Game
  def initialize
    @board = Board.new
    @current = :white
  end

  def play
    loop do
      @board.render
      puts "#{@current.capitalize}'s turn"
      input = gets.chomp

      # Special commands
      case input
      when "save"
        SaveLoad.save(self)
        next
      when "load"
        return SaveLoad.load.play
      when "exit"
        break
      end

      from, to = parse(input)

      if Move.valid?(@board, from, to, @current)
        @board.move(from, to)
        warn_check
        switch_player
      else
        puts "Illegal move."
      end
    end
  end

  # Convert chess notation like "e2 e4" to array positions
  def parse(str)
    from, to = str.split
    [ [ 8 - from[1].to_i, from[0].ord - 97 ],
     [ 8 - to[1].to_i, to[0].ord - 97 ] ]
  end

  # Switch turns between players
  def switch_player
    @current = @current == :white ? :black : :white
  end

  # Warn the player if they are putting the opponent in check
  def warn_check
    enemy = @current == :white ? :black : :white
    puts "Check!" if Move.check?(@board, enemy)
  end
end
