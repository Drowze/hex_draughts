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
require 'colorize'
require_relative './class_extenders'

require_relative './board_modifiers'
require_relative './board_questions'

require_relative './board'
require_relative './plays'

include BoardModifiers
include BoardQuestions

class Draughts
  WHITE = 0 ## lower side
  BLACK = 1
  def initialize
    @pieces_left = {
      'white' => 12,
      'black' => 12
    }
    @positions = Matrix[
        ['E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E'],
        ['E', 'E', 'E', 'E', 'E', 'o', 'o', ' ', 'o', 'E'],
        ['E', 'E', 'E', 'E', 'o', 'o', 'x', 'o', 'o', 'E'],
        ['E', 'E', 'E', 'o', ' ', 'o', 'o', ' ', 'o', 'E'],
        ['E', 'E', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'E'],
        ['E', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'E'],
        ['E', 'o', ' ', ' ', ' ', ' ', ' ', ' ', 'E', 'E'],
        ['E', 'x', ' ', 'x', 'x', ' ', 'x', 'E', 'E', 'E'],
        ['E', 'x', 'x', ' ', 'x', 'x', 'E', 'E', 'E', 'E'],
        ['E', 'x', 'x', 'x', 'x', 'E', 'E', 'E', 'E', 'E'],
        ['E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E']
    ]
    @board_pairs = Board.prepare_pairs
    @whose_turn = WHITE
  end

  def start_game
    loop do
      print_board(@positions)
      ask_player @whose_turn
      break if game_finished?(@pieces_left)
      @whose_turn = advance_turn(@whose_turn)
    end
    puts "Player white won the game!" if @whose_turn == WHITE
    puts "Player black won the game!" if @whose_turn == BLACK
    @whose_turn
  end

  def ask_player(color)
    print ' ' * 20

    puts "It's white's turn" if color == WHITE
    puts "It's black's turn" if color == BLACK

    pieces_left = {}
    loop do
      invalid_move = false
      @positions_aux = @positions.clone
      puts "\nPlease input your move below (eg \'d2 ne\' || \'c5 h4 nw\')"

      all_moves = Plays.new(gets.chomp.split)

      @positions_aux, pieces_left = all_moves.try_and_execute(@positions_aux, @whose_turn, @pieces_left)
      # implementar o huffling ou o cacete que for
      invalid_move = true if @positions_aux == false

      break unless invalid_move == true
      puts 'Invalid move attempted'
    end
    @positions = @positions_aux
    @pieces_left = pieces_left
  end

  def print_board(positions)
    print Board.prepare_board(positions)
  end

  def game_finished?(pieces_left)
    pieces_left['black'] <= 0 || pieces_left['white'] <= 0
  end

  def advance_turn(whose_turn)
    whose_turn += 1
    whose_turn % 2
  end

  def debugger
    $stderr.puts "#{@whose_turn}".red
  end
end

# Method list:
#  simple_move(positions, origin, direction)
#  make_capture(positions, origin, direction)
#  legal_move?(positions, cell, direction, whose_turn)
#  capture_valid?(positions, cell, xy, whose_turn)
#  there_a_piece?(positions, xy)
#  start_game
#  ask_player(whose_turn)
#  make_move(positions, cell_dir)
#  remove_enemy_piece
#  print_board
#  game_finished?
