require 'scanf'
require 'matrix'
require_relative './class_extenders'

require_relative './board'
require_relative './plays'

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
          invalid_move = true unless legal_move?(move[0], move[1])
          make_move(@positions_aux, all_moves)
        end
      else
        invalid_move = true
      end
      break unless invalid_move == true
      puts 'Invalid move attempted'
    end
  end

  def legal_move?(cell, direction)
    return false unless Board.cell_exists?(cell)
    return false unless Board.valid_direction?(direction)

    xy = Board.cell_to_coordinates(cell)
    dest = Board.calc_destination(xy[0], xy[1], direction) # destination
    return false if dest.nil? # dest out-of-bounds

    return false if there_a_piece?(dest).is_a?(Integer) && !capture_valid?(dest, direction) # this also checks for friendly pieces

    STDERR.puts 'Legal move'
    true
  end

  def make_move(positions, moves)
  end

  def there_a_piece?(xy) # Possible returns: BLACK, WHITE, -1
    return false unless %w(x X o O).include?(@positions[xy[0], xy[1]]) # There is no piece
    return WHITE if %w(x X).include?(@positions[xy[0], xy[1]])
    return BLACK if %w(o O).include?(@positions[xy[0], xy[1]])
  end

  def capture_valid?(xy, dir)
    enemy = %w(o O) if @whose_turn == WHITE
    enemy = %w(x X) if @whose_turn == BLACK
    inc_xy = Board.calc_destination(xy[0], xy[1], dir) # increased xy

    return false unless enemy.include?(@positions[xy[0], xy[1]])
    return false if there_a_piece?([inc_xy[0], inc_xy[1]]).is_a?(Integer)
    true
  end

  def print_board
    print Board.prepare_board(@positions)
  end

  def game_finished?
    @black_pieces_left == 0 || @white_pieces_left == 0
  end
end
