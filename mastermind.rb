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
    puts "#{circle_hint} - means correct color, wrong position\n"
    puts "#{filled_circle_hint} - means correct color, correct position\n\n"
    puts 'You will have 12 turns to figure out the code, Good Luck!'
  end

  def circle_hint
    "\u25CB".encode('utf-8')
  end

  def filled_circle_hint
    "\u25CF".encode('utf-8')
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
  attr_reader :code

  include Display
  def initialize
    @code = CodeMaker.new.code_generator
    welcome
    rules
  end

  def display_code
    format(code)
  end
end
