# REFERENCE
# color = WHITE or BLACK
# xy = Array[x, y]
# cell = String (e.g.: 7c)
# dir = sw OR se OR nw OR ne
#
# xy_dir => xy_dir[0] = xy, xy_dir[1] = dir
# cell_dir => cell[0] = cell, cell_dir[1] = dir
#

require 'scanf'
require 'matrix'
require_relative './class_extenders'

require_relative './movements'
require_relative './board_questions'

require_relative './board'
require_relative './plays'

include Movements
include BoardQuestions

class Draughts
  WHITE = 0 ## lower side
  BLACK = 1
  def initialize
    @positions = Matrix[
        ['E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E'],
        ['E', 'E', 'E', 'E', 'E', 'o', 'o', 'o', 'o', 'E'],
        ['E', 'E', 'E', 'E', 'o', 'o', ' ', 'o', 'o', 'E'],
        ['E', 'E', 'E', 'o', ' ', 'o', 'o', ' ', 'o', 'E'],
        ['E', 'E', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'E'],
        ['E', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'E'],
        ['E', 'o', ' ', ' ', ' ', ' ', ' ', ' ', 'E', 'E'],
        ['E', 'x', ' ', 'x', 'x', ' ', 'x', 'E', 'E', 'E'],
        ['E', 'x', 'x', ' ', 'x', 'x', 'E', 'E', 'E', 'E'],
        ['E', 'x', 'x', 'x', 'x', 'E', 'E', 'E', 'E', 'E'],
        ['E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E']
    ]
    # @positions_aux
    @board_pairs = Board.prepare_pairs
    @black_pieces_left = 12
    @white_pieces_left = 12
    @whose_turn = WHITE
  end

  def start_game
    print_board
    ask_player @whose_turn
    print_board
  end

  def ask_player(color)
    print ' ' * 20

    puts "It's white's turn" if color == WHITE
    puts "It's black's turn" if color == BLACK

    loop do
      invalid_move = false
      @positions_aux = @positions
      puts "\nPlease input your move below (eg \'d2 ne\' || \'c5 h4 nw\')"

      all_moves = Plays.new(gets.chomp.split)

      if Board.cell_exists?(all_moves.initial_position) && !all_moves.directions.empty?
        all_moves.each_move do |move| # move[0] = piece, move[1] = direction
          # implementar o huffling ou o cacete que for
          if legal_move?(move[0], move[1])
            make_move(@positions_aux, move)
            all_moves.shift
          else
            invalid_move = true
            break
          end
        end
      else
        invalid_move = true
      end
      break unless invalid_move == true
      puts 'Invalid move attempted'
    end
  end

  # make_move method expects that everything was checked beforehand
  def make_move(positions, cell_dir) # Returns the modified board
    $stderr.print(">> Trying to move piece #{cell_dir[0]} to #{cell_dir[1]}... ")

    origin = Board.cell_to_coordinates(cell_dir[0])
    destiny = Board.calc_destination(Board.cell_to_coordinates(cell_dir[0]), cell_dir[1])

    if there_a_piece?(destiny) == false
      positions = simple_move(positions, origin, cell_dir[1])
    else
      positions = make_capture(positions, origin, cell_dir[1])
      destiny = Board.calc_destination(destiny, cell_dir[1])
      @whose_turn == WHITE ? @black_pieces_left -= 1 : @white_pieces_left -= 1
      puts ''
    end

    $stderr.print("Moved to #{Board.coordinates_to_cell(destiny)}\n")
    return positions
  end

  def print_board
    print Board.prepare_board(@positions)
  end

  def game_finished?
    @black_pieces_left == 0 || @white_pieces_left == 0
  end

  ####          Below: make questions to your code
  def there_a_piece?(xy) # Possible returns: BLACK, WHITE, -1
    return false unless %w(x X o O).include?(@positions[xy[0], xy[1]]) # There is no piece
    return WHITE if %w(x X).include?(@positions[xy[0], xy[1]])
    return BLACK if %w(o O).include?(@positions[xy[0], xy[1]])
  end
end
