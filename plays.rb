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

  def try_and_execute(positions, whose_turn, pieces_left)
    return false unless Board.cell_exists?(@initial_position)
    return false if directions.empty?

    actual_cell = @initial_position
    actual_xy = Board.cell_to_coordinates(actual_cell)
    msg_stack = []
    it_was = ''

    directions_temp = @directions.clone

    @directions.each do |direction|
      if legal_move?(positions, actual_cell, direction, whose_turn) && it_was != 'move'
        it_was, positions, actual_xy, msg = make_move(positions, actual_cell, direction)
        actual_cell = Board.coordinates_to_cell(actual_xy)
        msg_stack << msg

        if it_was == 'capture'
          pieces_left, msg = remove_enemy_piece(whose_turn, pieces_left)
          msg_stack << msg
        end 
        directions_temp.shift
      else
        return false
      end
    end
    if directions_temp.empty?
      puts "\n", msg_stack
      [positions, pieces_left]
    else
      false
    end
  end

  def contains_huffing?
    @directions[0].to_i != 0
  end
end
