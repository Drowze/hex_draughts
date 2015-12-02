require_relative './board'
require_relative './class_extenders'
require_relative './plays'
require 'scanf'
require 'matrix'


class Draughts
  $white = 0 ## lower side
  $black = 1
  def initialize
    @positions = Matrix[
        ['E','E','E','E','E','E','E','E','E','E'],
         ['E','E','E','E','E','o','o','o','o','E'],
          ['E','E','E','E','o','o',' ','o','o','E'],
           ['E','E','E','o',' ','o','o',' ','o','E'],
            ['E','E',' ',' ',' ',' ',' ',' ',' ','E'],
             ['E',' ',' ',' ',' ',' ',' ',' ',' ','E'],
              ['E','o',' ',' ',' ',' ',' ',' ','E','E'],
               ['E','x',' ','x','x',' ','x','E','E','E'],
                ['E','x','x',' ','x','x','E','E','E','E'],
                 ['E','x','x','x','x','E','E','E','E','E'],
                  ['E','E','E','E','E','E','E','E','E','E']
    ]
    @board_pairs = Board.prepare_pairs
    @black_pieces_left = 12
    @white_pieces_left = 12
    @whose_turn = $white
  end

  def start_game
    print_board
    ask_player @whose_turn
  end

  def ask_player color
    print ' ' * 20
    
    puts "It's white's turn" if color == $white
    puts "It's black's turn" if color == $black
    loop do
      invalid_move = false
      temp_positions = @positions
      puts "\nPlease input your move below (eg \'d2 ne\' or \'c5 h4 nw\')"

      all_moves = Plays.new(gets.chomp.split)
      if @board_pairs.key(all_moves.initial_position) != nil
        all_moves.each_move(temp_positions) do |move| 
          piece = move[0]; direction = move[1]
          invalid_move = true unless legal_move?(piece,direction)
          puts legal_move?(piece,direction)
          make_move temp_positions,all_moves
        end
      else 
        invalid_move = true
      end
      break unless invalid_move == true
      puts 'Invalid move attempted'
    end
  end

  def make_move positions,moves

  end

  def legal_move? piece, direction
    return false unless @board_pairs.key(piece) # check if the cell exist
    
    piece = @board_pairs.key(piece).scanf("%d %d") # cell into "row column" (for the matrix)
    x = piece[0]; y = piece[1] # just to simplify future uses of those variables

    arr = ['x','X'] if @whose_turn == $white
    arr = ['o','O'] if @whose_turn == $black
    return false unless arr.include?(@positions[x, y]) # check if there's valid piece on the cell 
    return false unless (destination = calc_destination(x,y,direction)) != nil
    case is_there_a_piece?(destination)
      when @whose_turn then return false # Trying to move onto a friendly piece
      when (@whose_turn+1)%2 then # Trying to capture. Let's check!
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

  def calc_destination x, y, dir
    return nil unless Board::MOVES[dir] != nil
    ret_x = x + Board::MOVES[dir][0]
    ret_y = y + Board::MOVES[dir][1]
    ret = [ret_x, ret_y]
    return nil unless @board_pairs["#{ret_x.to_s} #{ret_y.to_s}"]
    ret
  end

  def is_there_a_piece? dest
    x = dest[0] ; y = dest[1]

    return -1 unless ['x','X','o','O'].include?(@positions[x,y]) # There is no piece
    return $white if ['x','X'].include?(@positions[x,y])
    return $black if ['o','O'].include?(@positions[x,y])
  end

  def capture_valid? dest, dir

    x = dest[0] ; y = dest[1]
    enemy = ['o','O'] if @whose_turn == $white
    enemy = ['x','X'] if @whose_turn == $black
    inc = calc_destination(x,y,dir)
    incx = inc[0] ; incy = inc[1]

    return false unless enemy.include?(@positions[x,y])
    return false unless @positions[incx,incy] != 'E'
    return false if is_there_a_piece?([incx,incy]) != -1
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