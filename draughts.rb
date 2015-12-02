require_relative './board.rb'
require 'scanf'

class Draughts
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
                 [' ','x','x','x','x',' ',' ',' ',' ',' ']
    ]
  end

  def print_board
  	print Board.prepare_board(@positions)
  end
end