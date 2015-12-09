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

      if !!@board_pairs.key(all_moves.initial_position) && !all_moves.directions.empty?
        all_moves.each_move do |move| # implementar o huffling ou o cacete que for
          piece = move[0]; direction = move[1]
          invalid_move = true unless legal_move?(piece, direction); STDERR.puts legal_move?(piece, direction)
          make_move(@positions_aux, all_moves)
        end
      else
        invalid_move = true
      end
      break unless invalid_move == true
      puts 'Invalid move attempted'
    end
  end

  def make_move(positions, moves)
  end

  def legal_move?(piece, direction)
    return false unless @board_pairs.key(piece) # check if the cell exist

    piece = @board_pairs.key(piece).scanf('%d %d') # cell into "row column" (for the matrix)
    x = piece[0]; y = piece[1] # just to simplify future uses of those variables

    arr = %w(x X) if @whose_turn == WHITE
    arr = %w(o O) if @whose_turn == BLACK
    return false unless arr.include?(@positions[x, y]) # check if there's valid piece on the cell

    return false if (destination = Board.calc_destination(x, y, direction)).nil?
    case there_a_piece?(destination)
    when @whose_turn then return false # Trying to move onto a friendly piece
    when (@whose_turn + 1) % 2 then # Trying to capture. Let's check!
      if capture_valid?(destination, direction)
        # Method to capture
      else
        return false
      end
    when -1 then nil
    else puts 'Error'
    end
    return true
  end

  def there_a_piece?(dest)
    x = dest[0]; y = dest[1]

    return -1 unless %w(x X o O).include?(@positions[x, y]) # There is no piece
    return WHITE if %w(x X).include?(@positions[x, y])
    return BLACK if %w(o O).include?(@positions[x, y])
  end

  def capture_valid?(dest, dir)
    x = dest[0]; y = dest[1]
    enemy = %w(o O) if @whose_turn == WHITE
    enemy = %w(x X) if @whose_turn == BLACK
    inc = Board.calc_destination(x, y, dir)
    incx = inc[0]; incy = inc[1]

    return false unless enemy.include?(@positions[x, y])
    return false unless @positions[incx, incy] != 'E'
    return false if there_a_piece?([incx, incy]) != -1
    return true
  end

  def print_board
    print Board.prepare_board(@positions)
  end

  def game_finished?
    @black_pieces_left == 0 || @white_pieces_left == 0
  end
end

=begin
  Moves: nw, ne, sw, se
=end
