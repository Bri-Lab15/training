#!/usr/bin/env ruby
# hangman.rb
#
# Usage:
#   ruby hangman.rb
#
# You should have a dictionary file in the same folder named:
#   google-10000-english-no-swears.txt
# or run with:
#   DICT=path/to/dict.txt ruby hangman.rb

require 'yaml'
require 'fileutils'
require 'securerandom'

DICT_PATH = (ENV['DICT'] || 'google-10000-english-no-swears.txt')
SAVES_DIR = 'saves'
MIN_LEN = 5
MAX_LEN = 12
MAX_INCORRECT = 6

# ---------------------------
# Helper / UI functions
# ---------------------------
def clear_screen
  print "\e[2J\e[f"
end

def pause
  puts "\nPress ENTER to continue..."
  STDIN.gets
end

def prompt(msg = '> ')
  print msg
  STDIN.gets&.chomp
end

def colorize_letter(ch)
  ch # keep plain; you can add colors if your terminal supports them
end

# ---------------------------
# Data structure for a game
# ---------------------------
class HangmanState
  attr_accessor :secret_word, :correct_guesses, :incorrect_guesses, :remaining_incorrect

  def initialize(secret_word:)
    @secret_word = secret_word.upcase
    @correct_guesses = []
    @incorrect_guesses = []
    @remaining_incorrect = MAX_INCORRECT
  end

  def masked_word
    @secret_word.chars.map { |c| @correct_guesses.include?(c) ? c : '_' }.join(' ')
  end

  def already_guessed?(letter)
    @correct_guesses.include?(letter) || @incorrect_guesses.include?(letter)
  end

  def guess_letter(letter)
    letter = letter.upcase
    return :invalid unless letter =~ /^[A-Z]$/
    return :already if already_guessed?(letter)

    if @secret_word.include?(letter)
      @correct_guesses << letter
      :correct
    else
      @incorrect_guesses << letter
      @remaining_incorrect -= 1
      :incorrect
    end
  end

  def won?
    # all letters in secret are in correct_guesses (handles repeated letters)
    @secret_word.chars.uniq.all? { |c| @correct_guesses.include?(c) }
  end

  def lost?
    @remaining_incorrect <= 0
  end

  def to_h
    {
      'secret_word' => @secret_word,
      'correct_guesses' => @correct_guesses,
      'incorrect_guesses' => @incorrect_guesses,
      'remaining_incorrect' => @remaining_incorrect
    }
  end

  def self.from_h(h)
    s = self.allocate
    s.secret_word = h['secret_word']
    s.correct_guesses = h['correct_guesses'] || []
    s.incorrect_guesses = h['incorrect_guesses'] || []
    s.remaining_incorrect = h['remaining_incorrect'] || MAX_INCORRECT
    s
  end
end

# ---------------------------
# Save / Load
# ---------------------------
def ensure_saves_dir
  FileUtils.mkdir_p(SAVES_DIR) unless Dir.exist?(SAVES_DIR)
end

def save_game(state, filename = nil)
  ensure_saves_dir
  filename ||= "hangman_#{Time.now.strftime('%Y%m%d_%H%M%S')}_#{SecureRandom.hex(3)}.yml"
  path = File.join(SAVES_DIR, filename)
  File.write(path, YAML.dump(state.to_h))
  path
end

def list_saves
  ensure_saves_dir
  Dir.glob(File.join(SAVES_DIR, '*.yml')).sort
end

def load_game(path)
  data = YAML.load_file(path)
  HangmanState.from_h(data)
rescue => e
  puts "Failed to load save: #{e}"
  nil
end

# ---------------------------
# Dictionary & Word selection
# ---------------------------
def load_dictionary(path)
  unless File.exist?(path)
    puts "Dictionary file not found: #{path}"
    puts "Download the file 'google-10000-english-no-swears.txt' into this directory or set DICT=path/to/file"
    exit(1)
  end

  words = File.readlines(path, chomp: true).map(&:strip)
  # filter only alphabetic & length constraints
  words.select! { |w| w =~ /\A[a-zA-Z]+\z/ && w.length.between?(MIN_LEN, MAX_LEN) }
  if words.empty?
    puts "No words found in dictionary matching length #{MIN_LEN}-#{MAX_LEN}."
    exit(1)
  end
  words
end

def pick_random_word(words)
  words.sample
end

# ---------------------------
# Main Game Loop
# ---------------------------
def start_new_game(words)
  secret = pick_random_word(words)
  HangmanState.new(secret_word: secret)
end

def show_status(state)
  puts "\nWord:    #{state.masked_word}"
  puts "Incorrect letters: #{state.incorrect_guesses.join(', ')}"
  puts "Remaining incorrect guesses: #{state.remaining_incorrect}"
end

def turn_menu(state)
  puts "\nType a single letter to guess."
  puts "Type 'save' to save the game."
  puts "Type 'quit' to quit without saving."
  prompt("> ")
end

def play_loop(state)
  loop do
    clear_screen
    puts "HANGMAN"
    show_status(state)

    if state.won?
      puts "\n🎉 You guessed the word: #{state.secret_word}"
      return :won
    end

    if state.lost?
      puts "\n💀 Out of guesses! The word was: #{state.secret_word}"
      return :lost
    end

    input = turn_menu(state)
    case input&.strip&.downcase
    when nil
      puts "No input detected. Try again."
      pause
      next
    when 'save'
      print "Enter a filename (or press ENTER to auto-generate): "
      fname = STDIN.gets&.chomp
      path = save_game(state, fname && !fname.empty? ? (fname.end_with?('.yml') ? fname : "#{fname}.yml") : nil)
      puts "Saved to #{path}"
      pause
      next
    when 'quit'
      puts "Quit without saving? (y/N)"
      confirm = prompt("> ").strip.downcase
      if confirm == 'y'
        puts "Quitting. Goodbye."
        exit(0)
      else
        next
      end
    else
      # treat as letter guess
      guess = input.strip.upcase
      if guess.length != 1 || guess !~ /[A-Z]/
        puts "Please enter a single letter A-Z."
        pause
        next
      end

      result = state.guess_letter(guess)
      case result
      when :invalid
        puts "Invalid input."
        pause
      when :already
        puts "You already guessed '#{guess}'."
        pause
      when :correct
        puts "Good! '#{guess}' is in the word."
        pause
      when :incorrect
        puts "Sorry, '#{guess}' is not in the word."
        pause
      end
    end
  end
end

# ---------------------------
# Top-level menu
# ---------------------------
def main
  clear_screen
  puts "Welcome to Hangman!"
  puts "Dictionary: #{DICT_PATH}"
  words = load_dictionary(DICT_PATH)

  loop do
    puts "\nMenu:"
    puts "1) Start a new game"
    puts "2) Load saved game"
    puts "3) Exit"
    choice = prompt("> ").to_s.strip

    case choice
    when '1'
      state = start_new_game(words)
      play_loop(state)
      break
    when '2'
      saves = list_saves
      if saves.empty?
        puts "No saved games found in '#{SAVES_DIR}'."
        next
      end

      puts "\nSaved games:"
      saves.each_with_index { |p, i| puts "#{i+1}) #{File.basename(p)}" }
      print "Choose a save number: "
      sel = STDIN.gets&.chomp.to_i
      if sel < 1 || sel > saves.length
        puts "Invalid selection."
        next
      end

      state = load_game(saves[sel - 1])
      unless state
        puts "Failed to load that save file."
        next
      end

      play_loop(state)
      break
    when '3', 'exit', 'quit'
      puts "Bye!"
      exit(0)
    else
      puts "Invalid selection. Choose 1, 2, or 3."
    end
  end
end

# ---------------------------
# Run
# ---------------------------
if __FILE__ == $0
  main
end
