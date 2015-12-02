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

  def legal_move? piece, direction
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
end

=begin
  Moves: nw, ne, sw, se
=end