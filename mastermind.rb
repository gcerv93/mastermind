# frozen_string_literal: true

require 'colorize'

# display methods
module Display
  def format(code)
    code.each do |n|
      print add_color(n, "  #{n}  ")
    end
  end

  # come back and refactor this, maybe with NumberColor class?
  # rubocop: disable Metrics/MethodLength
  def add_color(num, str)
    case num
    when 1
      str.black.on_light_cyan
    when 2
      str.black.on_light_magenta
    when 3
      str.black.on_light_green
    when 4
      str.black.on_light_red
    when 5
      str.black.on_light_yellow
    when 6
      str.black.on_light_blue
    end
  end
  # rubocop: enable Metrics/MethodLength

  def welcome
    puts "\nWelcome to Mastermind!"
  end

  def rules
    puts "\nYour goal is to guess the computers code."
    puts "\nThere are 6 different colors, each represented by a a different number, like so:  \n\n"
    format([1, 2, 3, 4, 5, 6])
    puts "\n\nYou must provide a guess each turn, after which you will be given a hint\n\n"
    puts "#{circle} - means correct color, wrong position\n"
    puts "#{filled_circle} - means correct color, correct position\n\n"
    puts 'You will have 12 turns to figure out the code, Good Luck!'
  end

  def circle
    "\u25CB".encode('utf-8')
  end

  def filled_circle
    "\u25CF".encode('utf-8')
  end

  def format_hints(hints)
    hint_string = ''
    hints.sort.each { |s| hint_string += " #{s}" }
    hint_string
  end

  def win_message
    puts "\nHoly crap! You cracked the code!!!"
  end
end

# class for the CodeMaker logic
class CodeMaker
  def code_generator
    4.times.map { rand(1..6) }
  end
end

# class for the game logic
class Game
  attr_reader :code, :turns, :hints

  include Display
  def initialize
    @code = CodeMaker.new.code_generator
    @turns = 1
    @hints = []
    game_start
  end

  def game_start
    welcome
    rules
    game_loop
  end

  def game_loop
    while turns <= 12
      puts "\nTurn #{turns}, take a guess: "
      display_guess(player_guess)
      if win?
        win_message
        break
      end
      hints.clear
      @turns += 1
    end
  end

  def display_code
    format(code)
  end

  def player_guess
    guess = gets.chomp
    if /[1-6]{4}/.match?(guess) && guess.length == 4
      guess.split('').map(&:to_i)
    else
      puts 'Invalid input! Please only 4 characters of numbers 1-6'
      player_guess
    end
  end

  def display_guess(guess)
    format(guess)
    check_guess(guess)
    display_hints(hints)
  end

  def check_guess(guess)
    copy_of_code = code.dup
    copy_of_guess = guess.dup
    guess.each_with_index do |n, idx|
      if n == code[idx]
        hints << filled_circle
        copy_of_guess[idx] = 'O'
        copy_of_code[idx] = 'X'
      end
    end
    check_guess_helper(copy_of_guess, copy_of_code)
  end

  def check_guess_helper(guess, copy)
    guess.each do |n|
      if copy.include?(n)
        hints << circle
        copy.delete_at(copy.index(n))
      end
    end
  end

  def display_hints(hints)
    print "    Hints: #{format_hints(hints)}\n"
  end

  def win?
    hints.all? { |h| h == filled_circle } && hints.length == 4
  end
end
