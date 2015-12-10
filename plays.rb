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

  # def each_move(positions)
  #   actual_cell = @initial_position
  #   actual_xy = Board.cell_to_coordinates(actual_cell)

  #   @directions.each do |direction|
  #     yield [actual_cell, direction]
  #     fail 'invalid direction' unless Board::MOVES[direction] # verify if directiin is valid
  #     actual_xy = Board.calc_destination(actual_xy, direction)

  #     actual_cell = Board.coordinates_to_cell(actual_xy)
  #   end
  # end

  def try_and_execute(positions, whose_turn, pieces_left)
    return false unless Board.cell_exists?(@initial_position)

    arr = %w(x X) if whose_turn == 0
    arr = %w(o O) if whose_turn == 1

    actual_cell = @initial_position
    actual_xy = Board.cell_to_coordinates(actual_cell)
    msg_stack = []

    @directions.each do |direction|
      if legal_move?(positions, actual_cell, direction, whose_turn)
        it_was, positions, actual_xy, msg = make_move(positions, actual_cell, direction)
        actual_cell = Board.coordinates_to_cell(actual_xy)
        msg_stack << msg

        if it_was == 'capture'
          pieces_left, msg = remove_enemy_piece(whose_turn, pieces_left)
          msg_stack << msg
        end
      else
        return false
      end
      Board.prepare_board(positions)
    end
    puts msg_stack
    [positions, whose_turn]
  end

  def contains_huffing?
    @directions[0].to_i != 0
  end
end
