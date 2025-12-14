

# COLORS USED IN THE GAME
COLORS = %w[R G B Y O P]  # Red, Green, Blue, Yellow, Orange, Purple

# ==========================
# Utility Helpers
# ==========================
class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
  def yellow; "\e[33m#{self}\e[0m" end
  def blue; "\e[34m#{self}\e[0m" end
  def magenta; "\e[35m#{self}\e[0m" end
  def cyan; "\e[36m#{self}\e[0m" end
end

def colorize(c)
  case c
  when "R" then c.red
  when "G" then c.green
  when "B" then c.blue
  when "Y" then c.yellow
  when "O" then c.cyan
  when "P" then c.magenta
  else c
  end
end

# ==========================
# Code Class
# ==========================
class Code
  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
  end

  def self.random
    Code.new(Array.new(4) { COLORS.sample })
  end

  def self.from_string(str)
    Code.new(str.upcase.strip.chars)
  end

  def to_s
    @pegs.map { |c| colorize(c) }.join(" ")
  end

  # Returns [black_pegs, white_pegs]
  def compare(guess)
    secret_copy = @pegs.dup
    guess_copy = guess.pegs.dup

    black = 0
    white = 0

    # Count black pegs (correct color & position)
    (0..3).each do |i|
      if guess_copy[i] == secret_copy[i]
        black += 1
        guess_copy[i] = nil
        secret_copy[i] = nil
      end
    end

    # Count white pegs (correct color, wrong position)
    (0..3).each do |i|
      next if guess_copy[i].nil?
      if secret_copy.include?(guess_copy[i])
        white += 1
        secret_copy[secret_copy.index(guess_copy[i])] = nil
      end
    end

    [ black, white ]
  end
end

# ==========================
# Human Player
# ==========================
class Human
  def pick_secret
    puts "Choose your secret code (4 letters, colors #{COLORS.join(', ')}):"
    loop do
      print "> "
      input = gets.chomp
      return Code.from_string(input) if valid?(input)
      puts "Invalid code. Try again."
    end
  end

  def guess
    puts "Enter your guess (4 letters):"
    loop do
      print "> "
      input = gets.chomp
      return Code.from_string(input) if valid?(input)
      puts "Invalid guess. Must be 4 of #{COLORS.join(', ')}."
    end
  end

  def valid?(str)
    str.length == 4 && str.upcase.chars.all? { |c| COLORS.include?(c) }
  end
end

# ==========================
# Computer Player
# ==========================
class Computer
  def initialize
    @known_correct_colors = []
  end

  def pick_secret
    Code.random
  end

  # Computer guessing strategy:
  # - Random guesses at first
  # - Keep colors confirmed to be in the code
  # - Add more of known colors if white pegs are found
  def guess(previous_feedback = nil)
    if previous_feedback
      black, white = previous_feedback
      @known_correct_colors += Array.new(black + white, COLORS.sample)
    end

    # Limit to 4 max items
    @known_correct_colors = @known_correct_colors.first(4)

    # Fill missing with random colors
    guess = @known_correct_colors.dup
    guess += Array.new(4 - guess.length) { COLORS.sample }

    Code.new(guess.shuffle)
  end
end

# ==========================
# Game Class
# ==========================
class Mastermind
  MAX_TURNS = 12

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    puts "Welcome to Mastermind!"
    puts "Colors: #{COLORS.map { |c| colorize(c) }.join(' ')}"
    puts "Would you like to:"
    puts "1) Guess the computer's secret code"
    puts "2) Create the code and let the computer guess"
    print "> "
    mode = gets.chomp

    if mode == "2"
      computer_guesses
    else
      human_guesses
    end
  end

  # ==========================
  # Mode 1: Human guesses
  # ==========================
  def human_guesses
    secret = @computer.pick_secret
    puts "\nComputer has chosen a secret code!"

    MAX_TURNS.times do |turn|
      puts "\nTurn #{turn + 1}/#{MAX_TURNS}"

      guess = @human.guess
      black, white = secret.compare(guess)

      puts "Your guess: #{guess}"
      puts "Feedback: #{black} black, #{white} white"

      if black == 4
        puts "\n🎉 You cracked the code!"
        return
      end
    end

    puts "\n❌ You failed to guess the code!"
  end

  # ==========================
  # Mode 2: Computer guesses
  # ==========================
  def computer_guesses
    secret = @human.pick_secret
    puts "\nYour secret code is set!"
    previous_feedback = nil

    MAX_TURNS.times do |turn|
      puts "\nTurn #{turn + 1}/#{MAX_TURNS}"

      guess = @computer.guess(previous_feedback)
      black, white = secret.compare(guess)

      puts "Computer guesses: #{guess}"
      puts "Feedback: #{black} black, #{white} white"

      if black == 4
        puts "\n🤖 The computer cracked your code!"
        return
      end

      previous_feedback = [ black, white ]
    end

    puts "\n🎉 Computer failed! You win!"
  end
end

# ==========================
# Start Game
# ==========================
Mastermind.new.play
