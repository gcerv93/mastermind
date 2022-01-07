# frozen_string_literal: true

# class for the CodeMaker logic
class CodeMaker
  attr_reader :code

  def initialize
    @code = code_generator
  end

  def code_generator
    4.times.map { rand(1..6) }
  end
end
