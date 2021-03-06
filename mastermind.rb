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
    puts "\nThe goal of the game is to make or break the code."
    puts "\nThere are 6 different colors, each represented by a a different number, like so:  \n\n"
    format([1, 2, 3, 4, 5, 6])
    puts "\n\nA guess must be provided each turn, after which a hint will be given.\n\n"
    puts "#{circle} - means correct color, wrong position\n"
    puts "#{filled_circle} - means correct color, correct position\n\n"
    puts 'A total of 12 turns will be given to figure out the code.'
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
end

# class for the CodeMaker logic
class Computer
  attr_accessor :comp_guess

  def initialize
    @comp_guess = [1, 1, 1, 1]
  end

  def code_generator
    4.times.map { rand(1..6) }
  end

  def generate_guess(length, array = [1, 1, 1, 1])
    return array.shuffle if length == 4

    array.map.with_index do |num, idx|
      length > -1 && idx >= length ? num + 1 : num
    end
  end

  def comp_win_message
    puts "\nDamn!! The computer cracked your code! :("
  end

  def comp_lose_message
    puts "\nThe computer could'nt break your code! You win!"
  end
end

# class for human player decisions
class Player
  include Display
  def input_code
    input = gets.chomp
    if /[1-6]{4}/.match?(input) && input.length == 4
      input.split('').map(&:to_i)
    else
      puts 'Invalid input! Please only 4 characters of numbers 1-6'
      input_code
    end
  end

  def choose_game_mode
    puts "\nWould you like to play CODEBREAKER or CODEMAKER?\n"
    puts "\nPress '1' for CODEBREAKER. Press '2' for CODEMAKER"
    answer = gets.chomp
    answer = gets.chomp until answer.downcase == '1' || answer.downcase == '2'
    answer
  end

  def play_again?
    puts "\nWould you like to play again?[Y/N]"
    answer = gets.chomp
    answer = gets.chomp until answer.downcase == 'y' || answer.downcase == 'n'
    answer.downcase == 'y' ? Game.new : (puts "\nGoodbye! Thanks for playing!")
  end

  def player_win_message
    puts "\nHoly crap! You cracked the code!!!"
  end

  def player_lose_message(code)
    puts "\nAww you lost, the code you were trying to crack was: \n\n"
    format(code)
    puts "\n\n"
  end
end

# class for the game logic
class Game
  attr_accessor :code
  attr_reader :turns, :hints, :computer, :player

  include Display
  def initialize
    @computer = Computer.new
    @player = Player.new
    @turns = 1
    @hints = []
    welcome
    game_start
  end

  private

  def game_start
    if player.choose_game_mode == '1'
      @code = computer.code_generator
      player_loop
    else
      puts 'Please enter a 4 digit code with each number between 1-6'
      @code = player.input_code
      comp_loop
      computer.comp_lose_message if turns == 13
    end
    player.play_again?
  end

  def player_loop
    while turns <= 12
      player_turn
      if win?
        player.player_win_message
        break
      end
      hints.clear
      @turns += 1
    end
    player.player_lose_message(code) if turns == 13
  end

  def comp_loop
    while turns <= 12
      comp_turn
      if win?
        computer.comp_win_message
        break
      end
      computer.comp_guess = computer.generate_guess(hints.length, computer.comp_guess)
      hints.clear
      @turns += 1
    end
  end

  def comp_turn
    puts "\nTurn #{turns}, take a guess: \n\n"
    display_guess(computer.comp_guess)
  end

  def player_turn
    puts "\nTurn #{turns}, take a guess: "
    display_guess(player.input_code)
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
