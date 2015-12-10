require_relative './board'
require_relative './board_modifiers'
require_relative './board_questions'

include BoardModifiers
include BoardQuestions

class Plays < Array
  attr_reader :initial_position, :directions

  def initialize(arr)
    @initial_position = arr.shift
    @directions = arr
  end

  def each_move
    actual_cell = @initial_position

    actual_xy = Board.cell_to_coordinates(actual_cell)

    @directions.each do |direction|
      yield [actual_cell, direction]
      fail 'invalid direction' unless Board::MOVES[direction] # verify if directiin is valid
      actual_xy = Board.calc_destination(actual_xy, direction)

      actual_cell = Board.coordinates_to_cell(actual_xy)
    end
  end

  def contains_huffing?
    @directions[0].to_i != 0
  end
end
