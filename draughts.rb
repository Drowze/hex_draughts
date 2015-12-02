require_relative './board.rb'
require 'scanf'

class Draughts
  $white = 0
  $black = 1
  def initialize
    @positions = Matrix[
        [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ','o','o','o','o',' '],
          [' ',' ',' ',' ','o','o',' ', 'o','o',' '],
           [' ',' ',' ', 'o',' ', 'o','o',' ', 'o',' '],
            [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
             [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
               [' ','x',' ','x','x',' ','x',' ',' ',' '],
                [' ','x','x',' ','x','x',' ',' ',' ',' '],
                 [' ','x','x','x','x',' ',' ',' ',' ',' '],
                  [' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']
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
      puts "\nPlease input your move below (eg \'d2 ne\' or \'c5 h4 nw\')"
      str = scanf("%s %s")
      if legal_move?(str) then
        break
      else
        puts 'invalid move'
      end
    end
  end

  def legal_move? str
    piece = str[0]
    direction = str[1]
    return false unless @board_pairs.key(piece) # check if the cell exist
    piece = @board_pairs.key(piece).scanf("%d %d") # cell is into "row column" (for the matrix)
    x = piece[0]
    y = piece[1]
    return false unless['x','X','o','O'].include?(@positions[x, y])
    return false unless['nw', 'ne', 'sw', 'se'].include?(direction) # check if direction is valid

    if direction == 'nw'
      if @positions[x-1,y] == ' '
        return true
      end
    end

    if direction == 'ne'
      if @positions[x-1,y+1] == ' '
        return true
      end
    end

    if direction == 'sw'
      if @positions[x+1,y-1] == ' '
        return true
      end
    end

    if direction == 'se'
      if @positions[x+1,y] == ' '
        return true
      end
    end

    return false
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