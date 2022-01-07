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
  end

  def display_code
    format(code)
  end
end
